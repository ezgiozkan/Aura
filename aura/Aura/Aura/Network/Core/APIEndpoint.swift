//
//  APIEndpoint.swift
//  Aura
//
//  Created by Ezgi Özkan on 7.01.2026.
//

import Foundation
import Alamofire

enum APIEndpoint {
    case checkAura(request: CheckAuraRequest)
    case generateRizz(request: GenerateRizzRequest)
    case generateChatReply(request: GenerateChatReplyRequest)

    static let baseURL = "https://aura-production-e333.up.railway.app"

    var path: String {
        switch self {
        case .checkAura:
            return "/check-aura"
        case .generateRizz:
            return "/generate-rizz"
        case .generateChatReply:
            return "/generate-chat-reply"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .checkAura, .generateRizz, .generateChatReply:
            return .post
        }
    }

    var url: String {
        switch self {
        case .checkAura(let request):
            return Self.baseURL + path + "?language=\(request.language)"
        case .generateRizz(let request):
            return Self.baseURL + path + "?language=\(request.language)"
        case .generateChatReply(let request):
            return Self.baseURL + path + "?language=\(request.language)"
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .checkAura, .generateRizz, .generateChatReply:
            return JSONEncoding.default
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .checkAura, .generateRizz, .generateChatReply:
            return ["Accept": "application/json"]
        }
    }
}
