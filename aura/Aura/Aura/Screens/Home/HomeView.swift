//
//  HomeView.swift
//  Aura
//
//  Created by Ezgi Özkan on 8.01.2026.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @StateObject private var languageManager = LanguageManager.shared
    @State private var isLanguageSheetPresented = false
    @State private var languageSearchText = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.homeGradient
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Image("iconAura")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                        .padding(.top, -10)

                    Spacer()

                    VStack(spacing: 0) {
                        Image("iconHome")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 1000)
                            .offset(y: -70)

                        VStack(spacing: 12) {
                            Text("For accurate analysis, you can upload screenshots directly from WhatsApp, Instagram DMs, Telegram, iMessage, and more.")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .offset(y: -70)
                                .padding(.horizontal, 32)

                            PhotosPicker(
                                selection: $viewModel.messagePhotoItem,
                                matching: .images
                            ) {
                                PrimaryButton(
                                    titleKey: "Upload Message Screenshot",
                                    background: .darkPurple,
                                    foreground: .white
                                ) {
                                    // PhotoPicker will handle this
                                }
                                .allowsHitTesting(false)
                            }
                            .onChange(of: viewModel.messagePhotoItem) { _, newItem in
                                Task {
                                    await viewModel.loadMessageImage(from: newItem)
                                }
                            }
                            .padding(.horizontal, 54)
                            .offset(y: 40)

                            PhotosPicker(
                                selection: $viewModel.storyPhotoItem,
                                matching: .images
                            ) {
                                PrimaryButton(
                                    titleKey: "Upload Instagram Story",
                                    background: .white,
                                    foreground: .darkPurple
                                ) {
                                    // PhotoPicker will handle this
                                }
                                .allowsHitTesting(false)
                            }
                            .onChange(of: viewModel.storyPhotoItem) { _, newItem in
                                Task {
                                    await viewModel.loadStoryImage(from: newItem)
                                }
                            }
                            .padding(.horizontal, 54)
                            .offset(y: 40)
                        }
                    }

                    Spacer()
                    Spacer()
                }
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            isLanguageSheetPresented = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "globe")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.black)

                                Text(languageManager.effectiveLanguageName)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.black)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color.white.opacity(0.65))
                            )
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 16)
                        .padding(.top, 14)
                    }
                    Spacer()
                }
            }
            .onAppear {
                languageManager.syncWithDeviceIfNeeded()
            }
            .fullScreenCover(item: $viewModel.selectedStoryImage) { identifiableImage in
                GenerateRizzView(selectedImage: identifiableImage.image)
            }
            .fullScreenCover(item: $viewModel.selectedMessageImage) { identifiableImage in
                GenerateChatReplyView(selectedImage: identifiableImage.image)
            }
            .sheet(isPresented: $isLanguageSheetPresented) {
                NavigationStack {
                    List {
                        Section {
                            HStack {
                                Text("Automatic")
                                    .foregroundStyle(.primary)
                                Spacer()
                                if !languageManager.userSelected {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.primary)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                languageManager.setAutomatic()
                                isLanguageSheetPresented = false
                            }
                            ForEach(languageManager.filteredLanguages(query: languageSearchText)) { lang in
                                HStack {
                                    Text(lang.name)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    if lang.code == languageManager.effectiveLanguageCode {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.primary)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    languageManager.setLanguage(code: lang.code)
                                    isLanguageSheetPresented = false
                                }
                            }
                        }
                    }
                    .navigationTitle("Language")
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: $languageSearchText, placement: .navigationBarDrawer(displayMode: .always))
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                isLanguageSheetPresented = false
                            }
                        }
                    }
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    HomeView()
}
