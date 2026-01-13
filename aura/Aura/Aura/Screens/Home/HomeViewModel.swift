//
//  HomeViewModel.swift
//  Aura
//
//  Created by Ezgi Özkan on 12.01.2026.
//

import SwiftUI
import PhotosUI

@Observable
final class HomeViewModel {
    var storyPhotoItem: PhotosPickerItem?
    var selectedStoryImage: IdentifiableImage?
    
    var messagePhotoItem: PhotosPickerItem?
    var selectedMessageImage: IdentifiableImage?
    
    @MainActor
    func loadStoryImage(from item: PhotosPickerItem?) async {
        guard let item = item else {
            return
        }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedStoryImage = IdentifiableImage(image: image)
            } else {
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }
    
    @MainActor
    func loadMessageImage(from item: PhotosPickerItem?) async {
        guard let item = item else {
            return
        }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedMessageImage = IdentifiableImage(image: image)
            } else {
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}

struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}
