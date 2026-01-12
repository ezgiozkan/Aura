//
//  CrushAnalyzerViewModel.swift
//  Aura
//
//  Created by Ezgi Özkan on 10.01.2026.
//

import SwiftUI
import PhotosUI

@MainActor
@Observable
class CrushAnalyzerViewModel {
    var yourPhoto: UIImage?
    var theirPhoto: UIImage?
    var yourPhotoItem: PhotosPickerItem?
    var theirPhotoItem: PhotosPickerItem?
    
    var isAnalyzing = false
    var analysisResponse: CheckAuraResponse?
    var errorMessage: String?
    
    private let service = AuraService.shared
    
    func loadYourPhoto() async {
        guard let item = yourPhotoItem else { return }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                yourPhoto = image
            }
        } catch {
            print("Error loading your photo: \(error)")
        }
    }
    
    func loadTheirPhoto() async {
        guard let item = theirPhotoItem else { return }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                theirPhoto = image
            }
        } catch {
            print("Error loading their photo: \(error)")
        }
    }
    
    func analyzeCrush() async {
        guard let yourPhoto = yourPhoto,
              let theirPhoto = theirPhoto,
              let yourImageData = yourPhoto.jpegData(compressionQuality: 0.8),
              let theirImageData = theirPhoto.jpegData(compressionQuality: 0.8) else {
            errorMessage = "Please select both photos"
            return
        }
        
        isAnalyzing = true
        errorMessage = nil
        
        do {
            let request = CheckAuraRequest(
                meImageData: yourImageData,
                targetImageData: theirImageData,
                meFileName: "you.jpg",
                targetFileName: "them.jpg",
                meMimeType: "image/jpeg",
                targetMimeType: "image/jpeg"
            )
            
            analysisResponse = try await service.checkAura(request: request)
            isAnalyzing = false
        } catch {
            isAnalyzing = false
            errorMessage = "Failed to analyze: \(error.localizedDescription)"
            print("Error analyzing crush: \(error)")
        }
    }
    
    var canAnalyze: Bool {
        yourPhoto != nil && theirPhoto != nil && !isAnalyzing
    }
}
