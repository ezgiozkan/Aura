//
//  SettingsView.swift
//  Aura
//
//  Created by Ezgi Özkan on 8.01.2026.
//

import SwiftUI
import UIKit

struct SettingsSheetView: View {
    @Binding var isPresented: Bool
    @Binding var shouldOpenLanguageAfterDismiss: Bool
    let languageName: String
    let languageFlag: String

    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)

                VStack(spacing: 0) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.35))
                        .frame(width: 44, height: 5)
                        .padding(.top, 8)

                    Spacer()
                }
                .padding(.horizontal, 0)
            }
            .frame(height: 30)
            .clipShape(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
            )
            .padding(.horizontal, 16)
            .padding(.top, 4)

            VStack(spacing: 0) {
                SettingsActionRow(
                    style: .standard(systemIcon: "envelope.fill"),
                    title: "Email Us",
                    trailing: .chevron
                ) {
                    openEmail()
                }

                Divider()

                SettingsActionRow(
                    style: .standard(systemIcon: "square.and.arrow.up"),
                    title: "Share App",
                    trailing: .chevron
                ) {
                    // no-op for now
                }

                Divider()

                SettingsActionRow(
                    style: .standard(systemIcon: "globe"),
                    title: "Language",
                    trailing: .language(flag: languageFlag, name: languageName)
                ) {
                    shouldOpenLanguageAfterDismiss = true
                    dismiss()
                }

                Divider()

                SettingsActionRow(
                    style: .upgrade,
                    title: "Upgrade to Pro",
                    trailing: .newBadgeAndChevron
                ) {
                    showPaywall = true
                }
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding(.horizontal, 16)
            .padding(.top, 12)

            Spacer(minLength: 0)
        }
        .background(Color(.systemGroupedBackground))
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView()
        }
    }
    private func openEmail() {
        let address = "eggzzys@gmail.com"
        guard let url = URL(string: "mailto:\(address)") else { return }
        UIApplication.shared.open(url)
    }
}


private enum SettingsTrailing {
    case chevron
    case language(flag: String, name: String)
    case newBadgeAndChevron
}

private enum SettingsRowStyle {
    case standard(systemIcon: String)
    case upgrade
}

private struct SettingsActionRow: View {
    let style: SettingsRowStyle
    let title: String
    let trailing: SettingsTrailing
    let action: () -> Void

    init(style: SettingsRowStyle, title: String, trailing: SettingsTrailing, action: @escaping () -> Void) {
        self.style = style
        self.title = title
        self.trailing = trailing
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                leadingIcon

                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(titleColor)

                Spacer(minLength: 0)

                trailingView
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var titleColor: Color {
        switch style {
        case .upgrade:
            return .purple
        case .standard:
            return .primary
        }
    }

    @ViewBuilder
    private var leadingIcon: some View {
        switch style {
        case .standard(let systemIcon):
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.purple.opacity(0.14))
                Image(systemName: systemIcon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.purple)
            }
            .frame(width: 46, height: 46)

        case .upgrade:
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.purple)
                Image(systemName: "star.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 46, height: 46)
        }
    }

    @ViewBuilder
    private var trailingView: some View {
        switch trailing {
        case .chevron:
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.secondary)

        case .language(let flag, let name):
            HStack(spacing: 10) {
                Text(flag)
                    .font(.system(size: 18))
                Text(name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.secondary)

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

        case .newBadgeAndChevron:
            HStack(spacing: 10) {
                Text("NEW")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.purple)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.purple.opacity(0.12))
                    )

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
    }
}
