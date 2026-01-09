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

    var title: String {
        switch self {
        case .home: return "Home"
        case .analyzer: return "Vibe"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .analyzer: return "heart.fill"
        }
    }
}
