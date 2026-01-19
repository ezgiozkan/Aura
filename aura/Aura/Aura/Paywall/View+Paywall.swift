//
//  View+Paywall.swift
//  Aura
//
//  Created by Ezgi Özkan on 19.01.2026.
//

import SwiftUI

extension View {
    func showPaywall(isPresented: Binding<Bool>) -> some View {
        self.sheet(isPresented: isPresented) {
            PaywallView()
        }
    }
    
    func requiresSubscription(
        isSubscribed: Bool,
        showPaywall: Binding<Bool>,
        action: @escaping () -> Void
    ) -> some View {
        self.onTapGesture {
            if isSubscribed {
                action()
            } else {
                showPaywall.wrappedValue = true
            }
        }
    }
}
