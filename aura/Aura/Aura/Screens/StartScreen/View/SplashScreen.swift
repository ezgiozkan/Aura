//
//  SplashScreen.swift
//  Aura
//
//  Created by Ezgi Özkan on 5.01.2026.
//

import SwiftUI

struct SplashView: View {
    let onFinished: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            WebView(htmlFileName: "dating-assistant-intro", onFinished: {
                print("🎬 Video finished!")
                onFinished()
            })
            .ignoresSafeArea()
        }
        .onAppear {
            print("🎬 SplashView appeared")
        }
    }
}
