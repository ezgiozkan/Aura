//
//  RizzService.swift
//  Aura
//
//  Created by Ezgi Özkan on 7.01.2026.
//

import Foundation
import Alamofire

@MainActor
final class RizzService {

    static let shared = RizzService()

    private let networkManager = NetworkManager.shared

    private init() {}

    func generateRizz(request: GenerateRizzRequest) async throws -> GenerateRizzResponse {
        let endpoint = APIEndpoint.generateRizz(request: request)
        
        return try await networkManager.upload(
            endpoint: endpoint,
            multipartFormData: { multipartFormData in
                request.appendMultipart(to: multipartFormData)
            
                if let extraContext = request.extraContext,
                   !extraContext.isEmpty,
                   let contextData = extraContext.data(using: .utf8) {
                    multipartFormData.append(
                        contextData,
                        withName: "extra_context"
                    )
                }
            },
            responseType: GenerateRizzResponse.self
        )
    }
}
