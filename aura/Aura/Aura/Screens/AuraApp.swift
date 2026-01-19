//
//  AuraApp.swift
//  Aura
//
//  Created by Ezgi Özkan on 5.01.2026.
//

import SwiftUI
import RevenueCat

@main
struct AuraApp: App {
    @StateObject private var revenueCatManager = RevenueCatManager.shared
    
    init() {
        Purchases.configure(withAPIKey: "appl_HHHEVVvWiCooPoGbbqmLqjjQmHK")
        Purchases.logLevel = .debug
    }
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(revenueCatManager)
        }
    }
}
//appl_HHHEVVvWiCooPoGbbqmLqjjQmHK
//test_jCvFrHnWeGgStTPyqCwOgrPNkAS
