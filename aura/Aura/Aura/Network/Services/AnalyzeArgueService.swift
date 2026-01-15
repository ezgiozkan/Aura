//
//  AnalyzeArgueService.swift
//  Aura
//
//  Created by Ezgi Özkan on 15.01.2026.
//

import Foundation
import Alamofire

final class AnalyzeArgueService {
    static let shared = AnalyzeArgueService()
    
    private init() {}
    
    nonisolated func analyzeArgue(request: AnalyzeArgueRequest) async throws -> AnalyzeArgueResponse {
        let endpoint = APIEndpoint.analyzeArgue(request: request)

        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(
                multipartFormData: { multipartFormData in
                    request.append(to: multipartFormData)
                },
                to: endpoint.url,
                method: endpoint.method,
                headers: endpoint.headers
            )
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        continuation.resume(throwing: NSError(domain: "AnalyzeArgueService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let decodedResponse = try decoder.decode(AnalyzeArgueResponse.self, from: data)
                        continuation.resume(returning: decodedResponse)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let data = response.data {
                        print("❌ Response data: \(String(data: data, encoding: .utf8) ?? "nil")")
                    }
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
