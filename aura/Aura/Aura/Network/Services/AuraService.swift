//
//  AuraService.swift
//  Aura
//
//  Created by Ezgi Özkan on 7.01.2026.
//

import Foundation
import Alamofire

@MainActor
final class AuraService {

    static let shared = AuraService()

    private let networkManager = NetworkManager.shared

    private init() {}

    func checkAura(request: CheckAuraRequest) async throws -> CheckAuraResponse {
        let endpoint = APIEndpoint.checkAura(request: request)
        
        return try await networkManager.upload(
            endpoint: endpoint,
            multipartFormData: { multipartFormData in
                request.append(to: multipartFormData)
            },
            responseType: CheckAuraResponse.self
        )
    }
}
