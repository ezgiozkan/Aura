//
//  RizzService.swift
//  Aura
//
//  Created by Ezgi Özkan on 7.01.2026.
//

import Foundation

/// /generate-rizz endpoint'i için servis
@MainActor
final class RizzService {
    
    // MARK: - Singleton
    static let shared = RizzService()
    
    // MARK: - Properties
    private let networkManager = NetworkManager.shared
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Public Methods
    
    /// Rizz cümleleri oluştur
    /// - Parameter request: GenerateRizzRequest objesi
    /// - Returns: GenerateRizzResponse objesi
    func generateRizz(request: GenerateRizzRequest) async throws -> GenerateRizzResponse {
        let endpoint = APIEndpoint.generateRizz(request: request)
        return try await networkManager.request(
            endpoint: endpoint,
            responseType: GenerateRizzResponse.self
        )
    }
    
    /// Rizz cümleleri oluştur (basitleştirilmiş)
    /// - Parameters:
    ///   - userId: Kullanıcı ID
    ///   - context: Konuşma bağlamı
    ///   - matchName: Eşleşen kişinin adı
    ///   - matchBio: Eşleşen kişinin biyografisi
    ///   - matchInterests: Eşleşen kişinin ilgi alanları
    /// - Returns: GenerateRizzResponse objesi
    func generateRizz(
        userId: String? = nil,
        context: String?,
        matchName: String? = nil,
        matchBio: String? = nil,
        matchInterests: [String]? = nil
    ) async throws -> GenerateRizzResponse {
        var matchProfile: GenerateRizzRequest.MatchProfile?
        
        if matchName != nil || matchBio != nil || matchInterests != nil {
            matchProfile = GenerateRizzRequest.MatchProfile(
                name: matchName,
                bio: matchBio,
                interests: matchInterests
            )
        }
        
        let request = GenerateRizzRequest(
            userId: userId,
            context: context,
            matchProfile: matchProfile
        )
        
        return try await generateRizz(request: request)
    }
}

// MARK: - Usage Example
/*
 
 Kullanım örneği:
 
 Task {
     do {
         let response = try await RizzService.shared.generateRizz(
             context: "First message to a match",
             matchName: "Emily",
             matchBio: "Love hiking and coffee",
             matchInterests: ["hiking", "coffee", "reading"]
         )
         
         print("Rizz Lines:")
         response.rizzLines?.forEach { print("- \($0)") }
         print("Confidence: \(response.confidence ?? 0)")
         
     } catch let error as NetworkError {
         print("Hata: \(error.errorDescription ?? "")")
     } catch {
         print("Bilinmeyen hata: \(error)")
     }
 }
 
 */
