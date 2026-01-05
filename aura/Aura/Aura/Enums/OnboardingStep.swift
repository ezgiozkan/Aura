//
//  OnboardingStep.swift
//  Aura
//
//  Created by Ezgi Özkan on 6.01.2026.
//

import Foundation

enum OnboardingStep: Int, CaseIterable {
    case firstImpression
    case context
    case uploadChat
    case exportChats
}

extension OnboardingStep {
    var titleKey: String {
        switch self {
        case .firstImpression:
            return "onboarding_title_first_impression"
        case .context:
            return "onboarding_title_context"
        case .uploadChat:
            return "onboarding_title_upload"
        case .exportChats:
            return "onboarding_title_export"
        }
    }

    var descriptionKey: String {
        switch self {
        case .firstImpression:
            return "onboarding_desc_first_impression"
        case .context:
            return "onboarding_desc_context"
        case .uploadChat:
            return "onboarding_desc_upload"
        case .exportChats:
            return "onboarding_desc_export"
        }
    }
}

func onboardingIconName(for index: Int) -> String {
    switch index {
    case 0: return "onboardingIcon1"
    case 1: return "onboardingIcon2"
    case 2: return "onboardingIcon3"
    case 3: return "onboardingIcon4"
    default: return "onboardingIcon1"
    }
}
