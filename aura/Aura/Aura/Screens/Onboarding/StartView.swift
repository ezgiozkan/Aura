//
//  StartView.swift
//  Aura
//
//  Created by Ezgi Özkan on 5.01.2026.
//

import SwiftUI

struct StartView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var step: AppFlowStep = .videoSplash

    var body: some View {
        ZStack {
            if hasCompletedOnboarding {
                AppTabView()
            } else {
                switch step {
                case .videoSplash:
                    SplashView(onFinished: {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            step = .onboarding
                        }
                    })

                case .preOnboarding:
                    PreOnboardingView(onFinished: {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            step = .onboarding
                        }
                    })

                case .onboarding:
                    OnboardingView()

                case .completed:
                    AppTabView()
                }
            }
        }
        .ignoresSafeArea()
        .onChange(of: hasCompletedOnboarding) { oldValue, newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.35)) {
                    step = .completed
                }
            }
        }
    }
}
