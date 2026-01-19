//
//  CrushAnalyzer.swift
//  Aura
//
//  Created by Ezgi Özkan on 8.01.2026.
//

import SwiftUI
import PhotosUI

struct CrushAnalyzer: View {
    @State private var viewModel = CrushAnalyzerViewModel()
    @State private var showAnalysisResult = false
    @StateObject private var manager = RevenueCatManager.shared
    @State private var showPaywall = false
    
    var body: some View {
        ZStack {
            Color.homeGradient
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text(LocalizedStringKey("crush_analyzer_title"))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 16)

                Text(LocalizedStringKey("crush_analyzer_subtitle"))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
                
                Spacer()
                    .frame(maxHeight: 40)

                ZStack {
                    HStack(spacing: 20) {

                        VStack(spacing: 16) {
                            Button {
                                if !manager.isSubscribed {
                                    showPaywall = true
                                }
                            } label: {
                                ZStack(alignment: .topTrailing) {
                                    PhotoUploadCard(image: viewModel.yourPhoto)
                                    
                                    if !manager.isSubscribed {
                                        HStack(spacing: 4) {
                                            Image(systemName: "lock.fill")
                                                .font(.system(size: 10, weight: .semibold))
                                            Text("Pro")
                                                .font(.system(size: 11, weight: .bold))
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(Color.black.opacity(0.6))
                                        )
                                        .offset(x: -8, y: 8)
                                    }
                                }
                            }
                            .overlay {
                                if manager.isSubscribed {
                                    PhotosPicker(selection: $viewModel.yourPhotoItem, matching: .images) {
                                        Color.clear
                                    }
                                }
                            }
                            .onChange(of: viewModel.yourPhotoItem) { _, _ in
                                Task {
                                    await viewModel.loadYourPhoto()
                                }
                            }
                            
                            VStack(spacing: 4) {
                                Text(LocalizedStringKey("crush_analyzer_you"))
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.primary)
                                
                                Text(LocalizedStringKey("crush_analyzer_select_photo"))
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.secondary)
                                    .opacity(0.6)
                            }
                        }

                        VStack(spacing: 16) {
                            Button {
                                if !manager.isSubscribed {
                                    showPaywall = true
                                }
                            } label: {
                                ZStack(alignment: .topTrailing) {
                                    PhotoUploadCard(image: viewModel.theirPhoto)
                                    
                                    if !manager.isSubscribed {
                                        HStack(spacing: 4) {
                                            Image(systemName: "lock.fill")
                                                .font(.system(size: 10, weight: .semibold))
                                            Text("Pro")
                                                .font(.system(size: 11, weight: .bold))
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(Color.black.opacity(0.6))
                                        )
                                        .offset(x: -8, y: 8)
                                    }
                                }
                            }
                            .overlay {
                                if manager.isSubscribed {
                                    PhotosPicker(selection: $viewModel.theirPhotoItem, matching: .images) {
                                        Color.clear
                                    }
                                }
                            }
                            .onChange(of: viewModel.theirPhotoItem) { _, _ in
                                Task {
                                    await viewModel.loadTheirPhoto()
                                }
                            }
                            
                            VStack(spacing: 4) {
                                Text(LocalizedStringKey("crush_analyzer_them"))
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.primary)
                                
                                Text(LocalizedStringKey("crush_analyzer_select_photo"))
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.secondary)
                                    .opacity(0.6)
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    Button(action: {
                        if manager.isSubscribed {
                            Task {
                                await viewModel.analyzeCrush()
                                if viewModel.analysisResponse != nil {
                                    showAnalysisResult = true
                                }
                            }
                        } else {
                            showPaywall = true
                        }
                    }) {
                        Image("iconAnalyze")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .scaleEffect(viewModel.canAnalyze ? 1.0 : 0.95)
                            .animation(
                                viewModel.canAnalyze ?
                                    Animation.easeInOut(duration: 0.8)
                                        .repeatForever(autoreverses: true) : .default,
                                value: viewModel.canAnalyze
                            )
                    }
                    .disabled(!viewModel.canAnalyze)
                    .opacity(viewModel.canAnalyze ? 1.0 : 0.5)
                }
                
                Spacer()
            
                PrimaryButton(
                    titleKey: "crush_analyzer_analyze_button",
                    icon: "sparkles",
                    background: .darkPurple,
                    foreground: .white
                ) {
                    Task {
                        await viewModel.analyzeCrush()
                        if viewModel.analysisResponse != nil {
                            showAnalysisResult = true
                        }
                    }
                }
                .disabled(!viewModel.canAnalyze)
                .opacity(viewModel.canAnalyze ? 1.0 : 0.5)
                .padding(.horizontal, 54)
                .padding(.bottom, 90)
            }

            if viewModel.isAnalyzing {
                AnalyzingOverlay()
            }
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView()
        }
        .fullScreenCover(isPresented: $showAnalysisResult) {
            if let response = viewModel.analysisResponse {
                NavigationStack {
                    CrushAnalysis(
                        response: response,
                        yourPhoto: viewModel.yourPhoto,
                        theirPhoto: viewModel.theirPhoto
                    )
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
        .alert(LocalizedStringKey("crush_analyzer_error_title"), isPresented: .constant(viewModel.errorMessage != nil)) {
            Button(LocalizedStringKey("crush_analyzer_error_ok")) {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    CrushAnalyzer()
}
