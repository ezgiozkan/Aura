//
//  OnboardingView.swift
//  Aura
//
//  Created by Ezgi Özkan on 5.01.2026.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentIndex: Int = 0
    @State private var selectedSex: String? = nil
    @State private var selectedAge: String? = nil
    @State private var selectedIntention: String? = nil
    private let totalCount: Int = 5

    private var step: OnboardingStep {
        OnboardingStep(rawValue: currentIndex) ?? .firstImpression
    }

    var body: some View {
        ZStack {
            Image("onboardingBackgroundIcon")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        if currentIndex > 0 {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentIndex = max(0, currentIndex - 1)
                                }
                            }) {
                                Image("icon_back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                            .padding(.leading, 20)
                        }

                        Spacer()
                    }

                    PageIndicator(currentIndex: currentIndex, totalCount: totalCount)
                }
                .frame(height: 44)
                .padding(.top, 12)

                VStack(spacing: 12) {
                    Text(LocalizedStringKey(step.titleKey))
                        .font(.custom("Inter-Bold", size: 28))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.top, 20)

                    Text(LocalizedStringKey(step.descriptionKey))
                        .font(.custom("Inter-Light", size: 16))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.horizontal, 40)
                }

                if currentIndex == 4 {
                    FinalStepContent(
                        selectedSex: $selectedSex,
                        selectedAge: $selectedAge,
                        selectedIntention: $selectedIntention
                    )
                }

                if currentIndex != 4 {
                    Image(onboardingIconName(for: currentIndex))
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 480)
                        .padding(.top, 42)
                }

                if currentIndex == 4 {
                    Spacer(minLength: 40)
                } else {
                    Spacer()
                }

                PrimaryButton(
                    titleKey: LocalizedStringKey("primary_next"),
                    isDisabled: currentIndex == 4 &&
                        (selectedSex == nil || selectedAge == nil || selectedIntention == nil)
                ) {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        currentIndex = min(totalCount - 1, currentIndex + 1)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
