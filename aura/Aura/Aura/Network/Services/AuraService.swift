//
//  AuraService.swift
//  Aura
//
//  Created by Ezgi Özkan on 7.01.2026.
//

import Foundation

/// /check-aura endpoint'i için servis
@MainActor
final class AuraService {
    
    // MARK: - Singleton
    static let shared = AuraService()
    
    // MARK: - Properties
    private let networkManager = NetworkManager.shared
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Public Methods
    
    /// Kullanıcının aura'sını kontrol et
    /// - Parameter request: CheckAuraRequest objesi
    /// - Returns: CheckAuraResponse objesi
    func checkAura(request: CheckAuraRequest) async throws -> CheckAuraResponse {
        let endpoint = APIEndpoint.checkAura(request: request)
        return try await networkManager.request(
            endpoint: endpoint,
            responseType: CheckAuraResponse.self
        )
    }
    
    /// Kullanıcının aura'sını kontrol et (basitleştirilmiş)
    /// - Parameters:
    ///   - userId: Kullanıcı ID
    ///   - sex: Cinsiyet
    ///   - age: Yaş aralığı
    ///   - intention: Amaç
    ///   - photos: Fotoğraf URL'leri
    /// - Returns: CheckAuraResponse objesi
    func checkAura(
        userId: String? = nil,
        sex: String?,
        age: String?,
        intention: String?,
        photos: [String]? = nil
    ) async throws -> CheckAuraResponse {
        let profileData = CheckAuraRequest.ProfileData(
            sex: sex,
            age: age,
            intention: intention,
            photos: photos
        )
        
        let request = CheckAuraRequest(
            userId: userId,
            profileData: profileData
        )
        
        return try await checkAura(request: request)
    }
}

// MARK: - Usage Example
/*
 
 Kullanım örneği:
 
 Task {
     do {
         let response = try await AuraService.shared.checkAura(
             sex: "male",
             age: "25-34",
             intention: "relationship"
         )
         
         print("Aura Score: \(response.auraScore ?? 0)")
         print("Feedback: \(response.feedback?.overall ?? "")")
         
     } catch let error as NetworkError {
         print("Hata: \(error.errorDescription ?? "")")
     } catch {
         print("Bilinmeyen hata: \(error)")
     }
 }
 
 */
