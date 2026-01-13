//
//  GenerateChatReplyView.swift
//  Aura
//
//  Created by Ezgi Özkan on 12.01.2026.
//

import SwiftUI

struct GenerateChatReplyView: View {
    let selectedImage: UIImage
    @State private var viewModel = GenerateChatReplyViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var selectedToneIndex: Int = 0
    
    let tones = ["😊", "😎", "🤗", "💬"]
    
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
                    
                    Text(LocalizedStringKey("reply_to_message"))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.primary)
                }
                .padding(.top, 50)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Text(LocalizedStringKey("analyze_message_description"))
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

                                ForEach(viewModel.allReplies, id: \.text) { reply in
                                    ChatReplyCard(reply: reply)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)

                            HStack(spacing: 12) {
                                Button(action: {
                                    selectedToneIndex = (selectedToneIndex + 1) % tones.count
                                }) {
                                    Text(tones[selectedToneIndex])
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
                                    Task {
                                        await viewModel.generateMoreReplies()
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 40)

                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            viewModel.selectedPhoto = selectedImage
            Task {
                await viewModel.generateChatReply()
            }
        }
    }
}

struct ChatReplyCard: View {
    let reply: ChatReply
    @State private var isCopied = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(reply.tone)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(1)
                
                Spacer()
                
                Button(action: {
                    UIPasteboard.general.string = reply.text
                    isCopied = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isCopied = false
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 14, weight: .medium))
                        Text(isCopied ? "Copied!" : "Copy")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundStyle(isCopied ? .green : .darkPurple)
                }
            }
            
            Text(reply.text)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.primary)
                .lineSpacing(4)
            
            if !reply.explanation.isEmpty {
                Text(reply.explanation)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
        )
    }
}

#Preview {
    GenerateChatReplyView(selectedImage: UIImage(systemName: "photo")!)
}
