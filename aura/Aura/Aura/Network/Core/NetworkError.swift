//
//  NetworkError.swift
//  Aura
//
//  Created by Ezgi Özkan on 7.01.2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(statusCode: Int, message: String?)
    case networkFailure(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from the server"
        case .decodingError(let error):
            return "Data processing error: \(error.localizedDescription)"
        case .serverError(let statusCode, let message):
            return "Server error (\(statusCode)): \(message ?? "Unknown error")"
        case .networkFailure(let error):
            return "Network connection error: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
