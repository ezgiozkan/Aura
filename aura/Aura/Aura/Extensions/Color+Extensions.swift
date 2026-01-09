//
//  Color+Extensions.swift
//  Aura
//
//  Created by Ezgi Özkan on 9.01.2026.
//

import SwiftUI

extension Color {
    static let gradientTopStart = Color(red: 0.85, green: 0.95, blue: 0.95)
    static let gradientBottomEnd = Color(red: 0.95, green: 0.85, blue: 0.92)

    static let homeGradient = LinearGradient(
        colors: [
            Color.gradientTopStart,
            Color.gradientBottomEnd
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
