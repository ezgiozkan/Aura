//
//  ArgueViewModel.swift
//  Aura
//
//  Created by Ezgi Özkan on 15.01.2026.
//

import SwiftUI
import PhotosUI

@MainActor
@Observable
final class ArgueViewModel {
    var photoItem: PhotosPickerItem?
    var selectedImage: UIImage?
    var isAnalyzing = false
    var errorMessage: String?
    var analysisResponse: AnalyzeArgueResponse?
    var isCardFlipped = false
    
    private let service = AnalyzeArgueService.shared
    
    func loadPhoto() async {
        guard let item = photoItem else { return }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
                await analyzeArgue()
            }
        } catch {
            errorMessage = "Failed to load image: \(error.localizedDescription)"
            print("Error loading photo: \(error)")
        }
    }
    
    func analyzeArgue() async {
        guard let selectedImage = selectedImage,
              let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            errorMessage = "Please select an image"
            return
        }
        
        isAnalyzing = true
        errorMessage = nil
        
        do {
            let request = AnalyzeArgueRequest(
                imageData: imageData,
                language: "Turkish",
                fileName: "argue.jpg",
                mimeType: "image/jpeg"
            )
            
            analysisResponse = try await service.analyzeArgue(request: request)
            isAnalyzing = false
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isCardFlipped = true
            }
        } catch {
            isAnalyzing = false
            errorMessage = "Failed to analyze: \(error.localizedDescription)"
            print("Error analyzing argue: \(error)")
        }
    }
    
    func toggleCard() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isCardFlipped.toggle()
        }
    }
}
