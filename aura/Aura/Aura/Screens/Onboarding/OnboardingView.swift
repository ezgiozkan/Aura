//
//  OnboardingView.swift
//  Aura
//
//  Created by Ezgi Özkan on 5.01.2026.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentIndex: Int = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    private let totalCount: Int = 4

    private var step: OnboardingStep {
        OnboardingStep(rawValue: currentIndex) ?? .firstImpression
    }

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                HomeView()
            } else {
                ZStack {
                    Color("onboardingBackground")
                        .ignoresSafeArea()

                    VStack(spacing: 0) {
                        PageIndicator(currentIndex: currentIndex, totalCount: totalCount)
                            .padding(.top, 16)
                            .padding(.bottom, 24)

                        Image(onboardingIconName(for: currentIndex))
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)

                        VStack(spacing: 12) {
                            Text(LocalizedStringKey(step.titleKey))
                                .font(.custom("Inter-Bold", size: 28))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)

                            if step == .uploadChat {
                                IconContainer()
                                    .padding(.top, 8)
                            } else {
                                if let descriptionKey = step.descriptionKey {
                                    Text(LocalizedStringKey(descriptionKey))
                                        .font(.system(size: 16, weight: .regular))
                                        .lineSpacing(4)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 32)
                                }
                            }
                        }
                        .padding(.top, 24)

                        Spacer()

                        PrimaryButton(
                            titleKey: LocalizedStringKey("primary_next"),
                            background: .black,
                            foreground: .white
                        ) {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                if currentIndex >= totalCount - 1 {
                                    hasCompletedOnboarding = true
                                } else {
                                    currentIndex = min(totalCount - 1, currentIndex + 1)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

struct IconContainer: View {
    var body: some View {
        Image("iconContainer")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 32)
    }
}

#Preview {
    OnboardingView()
}
