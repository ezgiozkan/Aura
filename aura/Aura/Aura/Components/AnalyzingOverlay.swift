//
//  AnalyzingOverlay.swift
//  Aura
//
//  Created by Ezgi Özkan on 10.01.2026.
//

import SwiftUI

struct AnalyzingOverlay: View {
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.6
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                ZStack {
                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: "heart.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.pink, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .opacity(opacity)
                            .scaleEffect(scale)
                            .rotationEffect(.degrees(rotationAngle + Double(index * 120)))
                            .offset(
                                x: cos(Angle(degrees: rotationAngle + Double(index * 120)).radians) * 50,
                                y: sin(Angle(degrees: rotationAngle + Double(index * 120)).radians) * 50
                            )
                    }
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 32))
                        .foregroundStyle(.white)
                        .scaleEffect(scale)
                }
                .frame(width: 150, height: 150)
                
                VStack(spacing: 8) {
                    Text("Analyzing Connection")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Please wait while we analyze the chemistry...")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
            )
            .padding(.horizontal, 40)
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                scale = 1.2
                opacity = 1.0
            }
        }
    }
}

#Preview {
    AnalyzingOverlay()
}
