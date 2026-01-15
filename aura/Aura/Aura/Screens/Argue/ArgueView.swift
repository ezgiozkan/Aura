//
//  ArgueView.swift
//  Aura
//
//  Created by Ezgi Özkan on 15.01.2026.
//

import SwiftUI
import PhotosUI

struct ArgueView: View {
    @State private var viewModel = ArgueViewModel()
    
    var body: some View {
        ZStack {
            Color.homeGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Text("Argue Analyzer")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .padding(.top, 16)

                    Text("Upload a screenshot of an argument or debate and let AI analyze who's winning!")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(height: 40)
                        .padding(.horizontal, 32)
                }
                
                Spacer()
                    .frame(height: 16)

                if let image = viewModel.selectedImage {
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 327, height: 520)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .opacity(viewModel.isCardFlipped ? 0 : 1)
                            .rotation3DEffect(
                                .degrees(viewModel.isCardFlipped ? 180 : 0),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .onTapGesture {
                                if !viewModel.isAnalyzing {
                                    viewModel.toggleCard()
                                }
                            }

                        if viewModel.isAnalyzing {
                            ScanningOverlay()
                                .frame(width: 327, height: 520)
                        }

                        if let response = viewModel.analysisResponse {
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(spacing: 12) {
                                    // Başlık
                                    Text("Argue Wrapped")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundStyle(.primary)
                                        .padding(.top, 16)
                                        
                                        // Winner & Score Card
                                        HStack(alignment: .top, spacing: 12) {
                                            // Winner
                                            VStack(spacing: 8) {
                                                HStack(spacing: 4) {
                                                    Image(systemName: "trophy.fill")
                                                        .font(.system(size: 14))
                                                        .foregroundStyle(.yellow)
                                                    Text("Winner")
                                                        .font(.system(size: 14, weight: .semibold))
                                                        .foregroundStyle(.primary)
                                                }
                                                
                                                Text(response.winner)
                                                    .font(.system(size: 20, weight: .bold))
                                                    .foregroundStyle(.primary)
                                                    .multilineTextAlignment(.center)
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 80)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                    .fill(Color.white.opacity(0.7))
                                                    .shadow(color: .purple.opacity(0.1), radius: 4, x: 0, y: 2)
                                            )
                                            
                                            // Score
                                            VStack(spacing: 8) {
                                                HStack(spacing: 4) {
                                                    Image(systemName: "star.fill")
                                                        .font(.system(size: 14))
                                                        .foregroundStyle(.purple)
                                                    Text("Score")
                                                        .font(.system(size: 14, weight: .semibold))
                                                        .foregroundStyle(.primary)
                                                }
                                                
                                                Text("\(response.score)%")
                                                    .font(.system(size: 20, weight: .bold))
                                                    .foregroundStyle(.primary)
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 80)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                    .fill(Color.white.opacity(0.7))
                                                    .shadow(color: .purple.opacity(0.1), radius: 4, x: 0, y: 2)
                                            )
                                        }
                                        .padding(.horizontal, 12)
                                        
                                        // Analysis
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "text.alignleft")
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.purple)
                                                Text("Analysis")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundStyle(.primary)
                                            }
                                            
                                            Text(response.analysis)
                                                .font(.system(size: 12, weight: .regular))
                                                .foregroundStyle(.secondary)
                                                .multilineTextAlignment(.leading)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .fill(Color.white.opacity(0.7))
                                                .shadow(color: .purple.opacity(0.1), radius: 4, x: 0, y: 2)
                                        )
                                        .padding(.horizontal, 12)
                                        
                                        HStack(alignment: .top, spacing: 12) {
                                            // Winning Point (Green)
                                            VStack(alignment: .leading, spacing: 6) {
                                                HStack(spacing: 4) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .font(.system(size: 12))
                                                        .foregroundStyle(.green)
                                                    Text("Winning Point")
                                                        .font(.system(size: 11, weight: .semibold))
                                                        .foregroundStyle(.primary)
                                                }
                                                
                                                Text(response.winningPoint)
                                                    .font(.system(size: 10, weight: .regular))
                                                    .foregroundStyle(.secondary)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                            .padding(10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(Color.green.opacity(0.1))
                                            )

                                            // Weak Point (Red)
                                            VStack(alignment: .leading, spacing: 6) {
                                                HStack(spacing: 4) {
                                                    Image(systemName: "exclamationmark.triangle.fill")
                                                        .font(.system(size: 12))
                                                        .foregroundStyle(.red)
                                                    Text("Weak Point")
                                                        .font(.system(size: 11, weight: .semibold))
                                                        .foregroundStyle(.primary)
                                                }
                                                
                                                Text(response.weakPoint)
                                                    .font(.system(size: 10, weight: .regular))
                                                    .foregroundStyle(.secondary)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                            .padding(10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(Color.red.opacity(0.1))
                                            )
                                        }
                                        .padding(.horizontal, 12)
                                        
                                        // Advice
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "lightbulb.fill")
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.yellow)
                                                Text("Advice")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundStyle(.primary)
                                            }
                                            
                                            Text(response.advice)
                                                .font(.system(size: 11, weight: .regular))
                                                .foregroundStyle(.secondary)
                                                .multilineTextAlignment(.leading)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .fill(Color.yellow.opacity(0.1))
                                                .shadow(color: .yellow.opacity(0.1), radius: 4, x: 0, y: 2)
                                        )
                                        .padding(.horizontal, 12)
                                        .padding(.bottom, 16)
                                }
                            }
                            .frame(width: 327, height: 520)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.95, green: 0.92, blue: 1.0),
                                        Color(red: 0.92, green: 0.88, blue: 1.0)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .opacity(viewModel.isCardFlipped ? 1 : 0)
                            .rotation3DEffect(
                                .degrees(viewModel.isCardFlipped ? 0 : -180),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .onTapGesture {
                                if !viewModel.isAnalyzing {
                                    viewModel.toggleCard()
                                }
                            }
                        } else {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.purple.opacity(0.1))
                                .frame(width: 327, height: 520)
                                .overlay(
                                    Text("Analysis Result")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundStyle(.primary)
                                )
                                .opacity(viewModel.isCardFlipped ? 1 : 0)
                                .rotation3DEffect(
                                    .degrees(viewModel.isCardFlipped ? 0 : -180),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                        }
                    }
                } else {
                    Image("iconHome")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 1000)
                }
                
                Spacer()
                
                PhotosPicker(selection: $viewModel.photoItem, matching: .images) {
                    HStack(spacing: 8) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 17, weight: .semibold))
                        
                        Text(viewModel.selectedImage == nil ? "Upload Screenshot" : "Try Another Photo")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(Color.black)
                    )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 68)
                .onChange(of: viewModel.photoItem) { _, _ in
                    Task {
                        await viewModel.loadPhoto()
                    }
                }
            }
        }
    }
}
