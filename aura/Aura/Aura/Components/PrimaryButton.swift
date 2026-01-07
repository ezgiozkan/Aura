//
//  PrimaryButton.swift
//  Aura
//
//  Created by Ezgi Özkan on 5.01.2026.
//

import SwiftUI

struct PrimaryButton: View {
    let titleKey: LocalizedStringKey
    var background: Color = .white
    var foreground: Color = .black
    var height: CGFloat = 56
    var cornerRadius: CGFloat = 28
    var isDisabled: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(titleKey)
                .font(.system(size: 17, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity)
                .frame(height: height)
        }
        .foregroundStyle(foreground)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .opacity(isDisabled ? 0.5 : 1.0)
        .disabled(isDisabled)
    }
}
