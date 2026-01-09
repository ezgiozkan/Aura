//
//  HomeView.swift
//  Aura
//
//  Created by Ezgi Özkan on 8.01.2026.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.homeGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Image("iconAura")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90)
                    .padding(.top, 5)

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
                        
                        PrimaryButton(
                            titleKey: "Upload Message Screenshot",
                            background: .darkPurple,
                            foreground: .white
                        ) {
                            // Upload action
                        }
                        .padding(.horizontal, 54)
                        .offset(y: 40)
                        
                        PrimaryButton(
                            titleKey: "Upload Instagram Story",
                            background: .white,
                            foreground: .darkPurple
                        ) {
                            // Upload story action
                        }
                        .padding(.horizontal, 54)
                        .offset(y: 40)
                    }
                }

                Spacer()
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
