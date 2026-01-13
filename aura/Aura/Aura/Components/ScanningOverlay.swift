//
//  ScanningOverlay.swift
//  Aura
//
//  Created by Ezgi Özkan on 12.01.2026.
//

import SwiftUI

struct ScanningOverlay: View {
    @State private var scanPosition: CGFloat = -300

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.purple.opacity(0.1))

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.purple.opacity(0),
                            Color.purple.opacity(0.8),
                            Color.purple.opacity(0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 4)
                .offset(y: scanPosition)
                .blur(radius: 2)

            VStack {
                HStack {
                    ScanCorner(position: .topLeft)
                    Spacer()
                    ScanCorner(position: .topRight)
                }
                Spacer()
                HStack {
                    ScanCorner(position: .bottomLeft)
                    Spacer()
                    ScanCorner(position: .bottomRight)
                }
            }
            .padding(12)
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 2.0)
                    .repeatForever(autoreverses: true)
            ) {
                scanPosition = 300
            }
        }
    }
}

#Preview {
    ScanningOverlay()
}
