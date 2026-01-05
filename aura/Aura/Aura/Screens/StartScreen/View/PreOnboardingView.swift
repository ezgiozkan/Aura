//
//  PreOnboardingView.swift
//  Aura
//
//  Created by Ezgi Özkan on 5.01.2026.
//

import SwiftUI

struct PreOnboardingView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            WebView(htmlFileName: "luxury-splash-profiles")
                .ignoresSafeArea()

            VStack {
                Spacer()

                PrimaryButton(titleKey: "primary_begin") {
                    // TODO: Navigate onboarding screen
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    PreOnboardingView()
}

