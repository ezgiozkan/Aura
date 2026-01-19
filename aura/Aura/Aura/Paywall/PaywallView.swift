//
//  PaywallView.swift
//  Aura
//
//  Created by Ezgi Özkan on 19.01.2026.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var manager = RevenueCatManager.shared
    
    var body: some View {
        Group {
            if let offering = manager.currentOffering {
                RevenueCatUI.PaywallView(offering: offering)
                    .onPurchaseCompleted { customerInfo in
                        print("✅ Purchase completed!")
                        dismiss()
                    }
                    .onRestoreCompleted { customerInfo in
                        print("✅ Restore completed!")
                        if manager.isSubscribed {
                            dismiss()
                        }
                    }
            } else {
                ProgressView("Loading...")
            }
        }
    }
}

#Preview {
    PaywallView()
}
