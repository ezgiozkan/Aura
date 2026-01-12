//
//  CrushAnalysis.swift
//  Aura
//
//  Created by Ezgi Özkan on 10.01.2026.
//

import SwiftUI

struct CrushAnalysis: View {
    let response: CheckAuraResponse
    let yourPhoto: UIImage?
    let theirPhoto: UIImage?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.homeGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack {
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundStyle(.primary)
                            }
                            .padding(.leading, 20)

                            Spacer()
                        }

                        Text(LocalizedStringKey("crush_analysis_title"))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.primary)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 24)

                    Text(LocalizedStringKey("crush_analysis_subtitle"))
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 32)

                    ZStack {
                        HStack(spacing: 32) {
                            VStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 140, height: 160)
                                    .overlay {
                                        if let yourPhoto = yourPhoto {
                                            Image(uiImage: yourPhoto)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 140, height: 160)
                                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                        } else {
                                            Color.gray.opacity(0.3)
                                                .cornerRadius(24)
                                        }
                                    }

                                Text(LocalizedStringKey("crush_analysis_you_label"))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 8)
                                    .background(Color.white)
                                    .cornerRadius(20)
                            }

                            VStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 140, height: 160)
                                    .overlay {
                                        if let theirPhoto = theirPhoto {
                                            Image(uiImage: theirPhoto)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 140, height: 160)
                                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                        } else {
                                            Color.gray.opacity(0.3)
                                                .cornerRadius(24)
                                        }
                                    }

                                Text(LocalizedStringKey("crush_analysis_them_label"))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 8)
                                    .background(Color.white)
                                    .cornerRadius(20)
                            }
                        }

                        Image("iconAnalyzer")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                    }
                    .padding(.bottom, 40)

                    ZStack {
                        Circle()
                            .stroke(Color.purple.opacity(0.2), lineWidth: 8)
                            .frame(width: 140, height: 140)

                        Circle()
                            .trim(from: 0, to: CGFloat(response.score) / 100.0)
                            .stroke(
                                Color.purple,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 140, height: 140)
                            .rotationEffect(.degrees(-90))

                        VStack(spacing: 2) {
                            Text("\(response.score)%")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundStyle(Color.purple)

                            Text(LocalizedStringKey("crush_analysis_match_label"))
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.purple.opacity(0.7))
                                .tracking(1.5)
                        }
                    }
                    .padding(.bottom, 32)

                    Text(response.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 12)

                    Text(AttributedString.parseDescription(response.description))
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 40)

                    VStack(spacing: 16) {
                        Text(LocalizedStringKey("crush_analysis_green_flags_title"))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.green)
                            .tracking(1.5)

                        VStack(spacing: 12) {
                            ForEach(Array(response.greenFlags.enumerated()), id: \.offset) { index, flag in
                                GreenFlagCard(text: flag)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)

                    VStack(spacing: 16) {
                        Text(LocalizedStringKey("crush_analysis_red_flags_title"))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.red.opacity(0.8))
                            .tracking(1.5)

                        VStack(spacing: 12) {
                            ForEach(Array(response.redFlags.enumerated()), id: \.offset) { index, flag in
                                RedFlagCard(text: flag)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)

                    VStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.darkPurple)

                            Text(LocalizedStringKey("crush_analysis_verdict_title"))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(Color.darkPurple)
                                .tracking(1.5)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.purple.opacity(0.2))
                        )

                        Text(response.verdict)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .padding(24)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.clear.opacity(0.8))
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}
