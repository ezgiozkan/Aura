//
//  PageIndicator.swift
//  Aura
//
//  Created by Ezgi Özkan on 6.01.2026.
//

import SwiftUI

struct PageIndicator: View {
    let currentIndex: Int
    let totalCount: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalCount, id: \.self) { index in
                Capsule()
                    .fill(index == currentIndex ? Color.white : Color.white.opacity(0.3))
                    .frame(width: index == currentIndex ? 22 : 6, height: 6)
            }
        }
    }
}
