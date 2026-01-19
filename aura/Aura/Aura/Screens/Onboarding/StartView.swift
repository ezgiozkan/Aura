//
//  StartView.swift
//  Aura
//
//  Created by Ezgi Özkan on 5.01.2026.
//

import SwiftUI
import StoreKit

struct StartView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("hasSeenInitialPaywall") private var hasSeenInitialPaywall: Bool = false
    @State private var step: AppFlowStep = .videoSplash
    @State private var showPaywall: Bool = false
    @StateObject private var manager = RevenueCatManager.shared
    @Environment(\.requestReview) private var requestReview

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
        .preferredColorScheme(.light)
        .onChange(of: hasCompletedOnboarding) { oldValue, newValue in
            if newValue {
                if !manager.isSubscribed && !hasSeenInitialPaywall {
                    showPaywall = true
                } else {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        step = .completed
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView()
                .onDisappear {
                    hasSeenInitialPaywall = true
                    withAnimation(.easeInOut(duration: 0.35)) {
                        step = .completed
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        requestReview()
                    }
                }
        }
        .onChange(of: step) { oldValue, newValue in
            if newValue == .completed && !showPaywall {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    requestReview()
                }
            }
        }
    }
}
