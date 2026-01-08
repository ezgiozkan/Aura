//
//  PreOnboardingView.swift
//  Aura
//
//  Created by Ezgi Özkan on 5.01.2026.
//

import SwiftUI

struct PreOnboardingView: View {
    let onFinished: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            WebView(htmlFileName: "aura-playful-splash", onFinished: {
            })
                .ignoresSafeArea()

            VStack {
                Spacer()
                PrimaryButton(titleKey: "primary_begin") {
                    onFinished()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    PreOnboardingView(onFinished: {})
}

