//
//  TabItem.swift
//  Aura
//
//  Created by Ezgi Özkan on 9.01.2026.
//

import Foundation

enum TabItem: Int, CaseIterable {
    case home
    case analyzer
    case argue

    var title: String {
        switch self {
        case .home: return "Home"
        case .analyzer: return "Vibe"
        case .argue: return "Argue"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .analyzer: return "heart.fill"
        case .argue: return "bubble.left.and.bubble.right.fill"
        }
    }
}
