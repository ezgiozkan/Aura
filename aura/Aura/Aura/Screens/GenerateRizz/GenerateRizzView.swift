//
//  GenerateRizzView.swift
//  Aura
//
//  Created by Ezgi Özkan on 12.01.2026.
//

import SwiftUI

struct GenerateRizzView: View {
    let selectedImage: UIImage
    @State private var viewModel = GenerateRizzViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRizzTone: RizzTone = .romantic
    @StateObject private var manager = RevenueCatManager.shared
    @State private var showPaywall: Bool = false

    var body: some View {
        ZStack {
            Color.homeGradient
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ZStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundStyle(.primary)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    
                    Text(LocalizedStringKey("reply_to_story"))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.primary)
                }
                .padding(.top, 50)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Text(LocalizedStringKey("analyze_story_description"))
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .padding(.bottom, 32)

                        ZStack {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: 600)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                            
                            if viewModel.isAnalyzing {
                                ScanningOverlay()
                                    .frame(maxWidth: .infinity)
                                    .frame(maxHeight: 600)
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)

                        if !viewModel.isAnalyzing {
                            VStack(spacing: 16) {
                                HStack(spacing: 12) {
                                    Rectangle()
                                        .fill(Color.secondary.opacity(0.3))
                                        .frame(height: 1)
                                    
                                    Text(LocalizedStringKey("replies_section_title"))
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.secondary)
                                        .tracking(2)
                                    
                                    Rectangle()
                                        .fill(Color.secondary.opacity(0.3))
                                        .frame(height: 1)
                                }

                                ForEach(viewModel.allReplies, id: \.self) { reply in
                                    ReplyCard(reply: reply)
                                        .transition(.asymmetric(
                                            insertion: .scale.combined(with: .opacity),
                                            removal: .scale.combined(with: .opacity)
                                        ))
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.allReplies)

                            HStack(spacing: 12) {
                                Button(action: {
                                    let currentIndex = selectedRizzTone.rawValue
                                    let nextIndex = (currentIndex + 1) % RizzTone.allCases.count
                                    selectedRizzTone = RizzTone(rawValue: nextIndex) ?? .romantic
                                }) {
                                    Text(selectedRizzTone.emoji)
                                        .font(.system(size: 28))
                                        .frame(width: 56, height: 56)
                                        .background(Circle().fill(Color.black.opacity(0.8)))
                                }
                                
                                PrimaryButton(
                                    titleKey: "generate_reply_button",
                                    icon: "sparkles",
                                    background: .darkPurple,
                                    foreground: .white
                                ) {
                                    if manager.isSubscribed {
                                        Task {
                                            await viewModel.generateMoreRizz(withContext: selectedRizzTone.context)
                                        }
                                    } else {
                                        showPaywall = true
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 40)
                        } else {
                            VStack(spacing: 16) {
                                HStack(spacing: 12) {
                                    Rectangle()
                                        .fill(Color.secondary.opacity(0.3))
                                        .frame(height: 1)
                                    
                                    Text(LocalizedStringKey("replies_section_title"))
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.secondary)
                                        .tracking(2)
                                    
                                    Rectangle()
                                        .fill(Color.secondary.opacity(0.3))
                                        .frame(height: 1)
                                }
                                
                                ForEach(0..<5, id: \.self) { _ in
                                    SkeletonReplyCard()
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .task(id: selectedImage) {
            viewModel.selectedPhoto = selectedImage
            await viewModel.generateRizz(withContext: selectedRizzTone.context)
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView()
        }
    }
}

#Preview {
    GenerateRizzView(selectedImage: UIImage(systemName: "photo")!)
}
