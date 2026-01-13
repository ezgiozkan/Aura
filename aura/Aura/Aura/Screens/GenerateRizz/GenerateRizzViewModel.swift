//
//  GenerateRizzViewModel.swift
//  Aura
//
//  Created by Ezgi Özkan on 12.01.2026.
//

import SwiftUI
import PhotosUI

@Observable
final class GenerateRizzViewModel {
    var selectedPhotoItem: PhotosPickerItem?
    var selectedPhoto: UIImage?
    var isAnalyzing: Bool = false
    var allReplies: [String] = [
        "Wow, bu harika görünüyor! 😍",
        "Vay canına, bugün muhteşem görünüyorsun! ✨",
        "Gözlerimi alamıyorum 🔥",
        "Bu fotoğraf çok güzel olmuş! 💫",
        "Kesinlikle harika bir görüntü 🌟"
    ]
    var rizzResponse: GenerateRizzResponse?
    var errorMessage: String?
    
    private let rizzService = RizzService.shared
    
    @MainActor
    func loadPhoto() async {
        guard let photoItem = selectedPhotoItem else { return }
        
        do {
            if let data = try await photoItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedPhoto = image
            }
        } catch {
            errorMessage = "Failed to load photo"
        }
    }
    
    @MainActor
    func generateRizz() async {
        guard let photo = selectedPhoto,
              let imageData = photo.jpegData(compressionQuality: 0.8) else { return }

        print("✅ Image data ready: \(imageData.count) bytes")
        
        isAnalyzing = true
        errorMessage = nil
    
        let startTime = Date()
        
        do {
            let currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"

            let request = GenerateRizzRequest(
                imageData: imageData,
                imageFileName: "story.jpg",
                imageMimeType: "image/jpeg",
                extraContext: nil,
                language: currentLanguage
            )

            let response = try await rizzService.generateRizz(request: request)

            let elapsedTime = Date().timeIntervalSince(startTime)
            let minimumDuration: TimeInterval = 12.0

            if elapsedTime < minimumDuration {
                let remainingTime = minimumDuration - elapsedTime
                try? await Task.sleep(nanoseconds: UInt64(remainingTime * 1_000_000_000))
            }
            
            rizzResponse = response
            allReplies = [
                "Wow, bu harika görünüyor! 😍",
                "Vay canına, bugün muhteşem görünüyorsun! ✨",
                "Gözlerimi alamıyorum 🔥",
                "Bu fotoğraf çok güzel olmuş! 💫",
                "Kesinlikle harika bir görüntü 🌟"
            ]
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isAnalyzing = false
    }

    @MainActor
    func generateMoreRizz() async {
        guard let photo = selectedPhoto,
              let imageData = photo.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        do {
            let currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            
            let request = GenerateRizzRequest(
                imageData: imageData,
                imageFileName: "story.jpg",
                imageMimeType: "image/jpeg",
                extraContext: nil,
                language: currentLanguage
            )

            let response = try await rizzService.generateRizz(request: request)

            let newReplies = response.options.map { $0.text }
            allReplies.append(contentsOf: newReplies)
            
        } catch {
            print("❌ Error generating more: \(error.localizedDescription)")
        }
    }
}
