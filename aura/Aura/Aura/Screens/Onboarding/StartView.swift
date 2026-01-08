//
//  StartView.swift
//  Aura
//
//  Created by Ezgi Özkan on 5.01.2026.
//

import SwiftUI

struct StartView: View {
    @State private var step: AppFlowStep = .onboarding

    var body: some View {
        ZStack {
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
            }
        }
        .background(Color("darkPurple").ignoresSafeArea())
    }
}
