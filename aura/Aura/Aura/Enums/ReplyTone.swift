//
//  ReplyTone.swift
//  Aura
//
//  Created by Ezgi Özkan on 15.01.2026.
//

import Foundation

enum ReplyTone: Int, CaseIterable {
    case friendly = 0
    case sensual = 1
    case flirty = 2
    case romantic = 3

    var emoji: String {
        switch self {
        case .friendly: return "😊"
        case .sensual: return "😈"
        case .flirty: return "😏"
        case .romantic: return "❤️"
        }
    }

    var name: String {
        switch self {
        case .friendly: return "friendly"
        case .sensual: return "sensual"
        case .flirty: return "flirty"
        case .romantic: return "romantic"
        }
    }

    var context: String {
        switch self {
        case .friendly:
            return "Generate friendly and cheerful replies, suitable for casual conversations. Be warm and approachable."
        case .sensual:
            return "Generate sensual and seductive replies. Be bold, provocative, and intensely alluring. Create tension and desire with passionate language. Go beyond flirting to something more intimate and daring."
        case .flirty:
            return "Generate flirty and playful replies. Be charming, teasing, and subtly romantic. Use wit and playfulness."
        case .romantic:
            return "Generate romantic and heartfelt replies. Be sweet, caring, and affectionate. Express genuine feelings."
        }
    }
}
