//
//  PrimaryButton.swift
//  Aura
//
//  Created by Ezgi Özkan on 5.01.2026.
//

import SwiftUI

struct PrimaryButton: View {
    let titleKey: LocalizedStringKey
    var icon: String? = nil
    var background: Color = .black
    var foreground: Color = .white
    var height: CGFloat = 56
    var cornerRadius: CGFloat = 28
    var isDisabled: Bool = false
    var action: () -> Void
    
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .semibold))
                }
                
                Text(titleKey)
                    .font(.system(size: 17, weight: .semibold, design: .default))
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
        }
        .foregroundStyle(foreground)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .opacity(isDisabled ? 0.5 : 1.0)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .disabled(isDisabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}
