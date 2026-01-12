//
//  PhotoUploadCard.swift
//  Aura
//
//  Created by Ezgi Özkan on 10.01.2026.
//

import SwiftUI

struct PhotoUploadCard: View {
    let image: UIImage?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8, 8]))
                .foregroundStyle(.secondary.opacity(0.6))
                .frame(width: 160, height: 220)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(.ultraThinMaterial)
                )

            VStack(spacing: 12) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                } else {
                    Image("iconAdd")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)

                    Text("Tap to upload")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
