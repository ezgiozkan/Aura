//
//  ChatReplyService.swift
//  Aura
//
//  Created by Ezgi Özkan on 12.01.2026.
//

import Foundation
import Alamofire

final class ChatReplyService {
    static let shared = ChatReplyService()
    
    private init() {}
    
    nonisolated func generateChatReply(request: GenerateChatReplyRequest) async throws -> GenerateChatReplyResponse {
        let endpoint = APIEndpoint.generateChatReply(request: request)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(
                multipartFormData: { multipartFormData in
                    request.appendMultipart(to: multipartFormData)
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
                        continuation.resume(throwing: NSError(domain: "ChatReplyService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let decodedResponse = try decoder.decode(GenerateChatReplyResponse.self, from: data)
                        continuation.resume(returning: decodedResponse)
                    } catch {
                        print("❌ Chat Reply Decoding Error: \(error)")
                        print("❌ Response data: \(String(data: data, encoding: .utf8) ?? "nil")")
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("❌ Chat Reply Error: \(error)")
                    if let data = response.data {
                        print("❌ Response data: \(String(data: data, encoding: .utf8) ?? "nil")")
                    }
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
