//
//  ReplyCard.swift
//  Aura
//
//  Created by Ezgi Özkan on 12.01.2026.
//

import SwiftUI

struct ReplyCard: View {
    let reply: String

    var body: some View {
        HStack(spacing: 12) {
            Text(reply)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {
                UIPasteboard.general.string = reply
            }) {
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 18))
                    .foregroundStyle(.purple)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
        )
    }
}
