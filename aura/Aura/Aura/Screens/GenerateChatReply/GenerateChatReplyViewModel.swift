//
//  GenerateChatReplyViewModel.swift
//  Aura
//
//  Created by Ezgi Özkan on 12.01.2026.
//

import SwiftUI
import PhotosUI

@Observable
final class GenerateChatReplyViewModel {
    var selectedPhotoItem: PhotosPickerItem?
    var selectedPhoto: UIImage?
    var isAnalyzing: Bool = false
    var allReplies: [ChatReply] = []
    var chatReplyResponse: GenerateChatReplyResponse?
    var errorMessage: String?
    var hasInitiallyLoaded: Bool = false
    
    private let chatReplyService = ChatReplyService.shared
    
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
    func generateChatReply(withContext context: String? = nil, tone: String = "friendly") async {
        guard !hasInitiallyLoaded else {
            print("⚠️ Already loaded, skipping duplicate request")
            return
        }
        
        guard let photo = selectedPhoto,
              let imageData = photo.jpegData(compressionQuality: 0.8) else { return }

        print("✅ Image data ready: \(imageData.count) bytes")
        
        hasInitiallyLoaded = true
        isAnalyzing = true
        errorMessage = nil
    
        let startTime = Date()
        
        do {
            let currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"

            let request = GenerateChatReplyRequest(
                imageData: imageData,
                imageFileName: "message.jpg",
                imageMimeType: "image/jpeg",
                extraContext: context,
                tone: tone,
                language: currentLanguage
            )

            let response = try await chatReplyService.generateChatReply(request: request)

            let elapsedTime = Date().timeIntervalSince(startTime)
            let minimumDuration: TimeInterval = 12.0

            if elapsedTime < minimumDuration {
                let remainingTime = minimumDuration - elapsedTime
                try? await Task.sleep(nanoseconds: UInt64(remainingTime * 1_000_000_000))
            }
            
            chatReplyResponse = response
            allReplies = response.replies
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isAnalyzing = false
    }

    @MainActor
    func generateMoreReplies(withContext context: String? = nil, tone: String = "friendly") async {
        guard let photo = selectedPhoto,
              let imageData = photo.jpegData(compressionQuality: 0.8) else {
            return
        }

        isAnalyzing = true
        allReplies = []
        errorMessage = nil
        
        let startTime = Date()
        
        do {
            let currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            
            let request = GenerateChatReplyRequest(
                imageData: imageData,
                imageFileName: "message.jpg",
                imageMimeType: "image/jpeg",
                extraContext: context,
                tone: tone,
                language: currentLanguage
            )

            let response = try await chatReplyService.generateChatReply(request: request)
            
            let elapsedTime = Date().timeIntervalSince(startTime)
            let minimumDuration: TimeInterval = 3.0
            
            if elapsedTime < minimumDuration {
                let remainingTime = minimumDuration - elapsedTime
                try? await Task.sleep(nanoseconds: UInt64(remainingTime * 1_000_000_000))
            }

            allReplies = response.replies
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error generating more: \(error.localizedDescription)")
        }
        
        isAnalyzing = false
    }
}
