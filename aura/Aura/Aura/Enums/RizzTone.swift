//
//  RizzTone.swift
//  Aura
//
//  Created by Ezgi Özkan on 15.01.2026.
//

import Foundation

enum RizzTone: Int, CaseIterable {
    case romantic = 0
    case seductive = 1
    case friendly = 2
    case passionate = 3

    var emoji: String {
        switch self {
        case .romantic: return "❤️"
        case .seductive: return "😈"
        case .friendly: return "🤗"
        case .passionate: return "💋"
        }
    }

    var context: String {
        switch self {
        case .romantic:
            return "Generate romantic and loving replies, suitable for a partner or someone you're dating. Be sweet and affectionate."
        case .seductive:
            return "Generate flirty and playful replies with a sexy, confident tone. Be bold and seductive."
        case .friendly:
            return "Generate friendly and warm replies, suitable for close friends. Be casual and supportive."
        case .passionate:
            return "Generate passionate and flirtatious replies. Be charming and expressive."
        }
    }
}
