//
//  RevenueCatManager.swift
//  Aura
//
//  Created by Ezgi Özkan on 19.01.2026.
//

import Foundation
import RevenueCat
import SwiftUI
import Combine

@MainActor
class RevenueCatManager: NSObject, ObservableObject {
    static let shared = RevenueCatManager()
    
    @Published var isSubscribed: Bool = false
    @Published var currentOffering: Offering?
    @Published var customerInfo: CustomerInfo?
    @Published var isLoading: Bool = false

    private let entitlementID = "Aura Pro"
    
    private override init() {
        super.init()
        setupPurchasesDelegate()
        Task {
            await checkSubscriptionStatus()
            await fetchOfferings()
        }
    }

    private func setupPurchasesDelegate() {
        Purchases.shared.delegate = self
    }

    func checkSubscriptionStatus() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            self.customerInfo = customerInfo
            self.isSubscribed = customerInfo.entitlements.all[entitlementID]?.isActive == true
        } catch {
            print("❌ RevenueCat Error: Failed to fetch customer info - \(error.localizedDescription)")
            self.isSubscribed = false
        }
    }

    func fetchOfferings() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let offerings = try await Purchases.shared.offerings()
            self.currentOffering = offerings.current
            
            if let current = offerings.current {
                print("✅ Current Offering: \(current.identifier)")
                print("📦 Available Packages: \(current.availablePackages.count)")
            } else {
                print("⚠️ No current offering found")
            }
        } catch {
            print("❌ RevenueCat Error: Failed to fetch offerings - \(error.localizedDescription)")
        }
    }

    func purchase(package: Package) async throws -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Purchases.shared.purchase(package: package)
            self.customerInfo = result.customerInfo
            self.isSubscribed = result.customerInfo.entitlements.all[entitlementID]?.isActive == true
            
            if isSubscribed {
                print("✅ Purchase successful! User is now subscribed.")
            }
            
            return isSubscribed
        } catch let error as ErrorCode {
            if error == .purchaseCancelledError {
                print("⚠️ User cancelled the purchase")
            } else if error == .storeProblemError {
                print("❌ Store problem: \(error.localizedDescription)")
            } else {
                print("❌ Purchase failed: \(error.localizedDescription)")
            }
            throw error
        }
    }

    func restorePurchases() async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            self.customerInfo = customerInfo
            self.isSubscribed = customerInfo.entitlements[entitlementID]?.isActive == true
            
            if isSubscribed {
                print("✅ Purchases restored successfully!")
            } else {
                print("⚠️ No active subscriptions found")
            }
        } catch {
            print("❌ Restore failed: \(error.localizedDescription)")
            throw error
        }
    }

    @Published var isPresentingPaywall: Bool = false
    
    func presentPaywall() {
        isPresentingPaywall = true
    }
    
    func dismissPaywall() {
        isPresentingPaywall = false
    }

    var subscriptionExpirationDate: Date? {
        guard let entitlement = customerInfo?.entitlements.all[entitlementID] else {
            return nil
        }
        return entitlement.expirationDate
    }
    
    var subscriptionPeriodType: String? {
        guard let entitlement = customerInfo?.entitlements.all[entitlementID] else {
            return nil
        }
        
        switch entitlement.periodType {
        case .normal:
            return "normal"
        case .intro:
            return "intro"
        case .trial:
            return "trial"
        @unknown default:
            return "unknown"
        }
    }
    
    var isActiveSubscriber: Bool {
        guard let entitlement = customerInfo?.entitlements.all[entitlementID] else {
            return false
        }
        return entitlement.isActive
    }
}

extension RevenueCatManager: PurchasesDelegate {
    nonisolated func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        Task { @MainActor in
            self.customerInfo = customerInfo
            self.isSubscribed = customerInfo.entitlements[self.entitlementID]?.isActive == true
            print("🔄 Customer info updated. Subscribed: \(self.isSubscribed)")
        }
    }
}
