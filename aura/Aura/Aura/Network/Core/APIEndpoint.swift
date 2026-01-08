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

    static let baseURL = "https://aura-production-e333.up.railway.app"

    var path: String {
        switch self {
        case .checkAura:
            return "/check-aura"
        case .generateRizz:
            return "/generate-rizz"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .checkAura, .generateRizz:
            return .post
        }
    }

    var url: String {
        return Self.baseURL + path
    }

    var encoding: ParameterEncoding {
        switch self {
        case .checkAura, .generateRizz:
            return JSONEncoding.default
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
