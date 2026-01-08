//
//  OptionChip.swift
//  Aura
//
//  Created by Ezgi Özkan on 7.01.2026.
//

import SwiftUI

struct OptionChip: View {
    let titleKey: LocalizedStringKey
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(titleKey)
                .font(.system(size: 14, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Color.white : Color.white.opacity(0.15))
                .foregroundStyle(isSelected ? .black : .white)
                .clipShape(Capsule())
        }
    }
}
