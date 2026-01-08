//
//  NetworkManager.swift
//  Aura
//
//  Created by Ezgi Özkan on 7.01.2026.
//

import Foundation
import Alamofire

@MainActor
final class NetworkManager {

    // MARK: - Singleton
    static let shared = NetworkManager()
    
    // MARK: - Properties
    private let session: Session

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = Session(configuration: configuration)
    }
    
    /// Generic network request method
    /// - Parameters:
    ///   - endpoint: API endpoint
    ///   - responseType: Cadable
    /// - Returns: Response object or Error
    func request<T: Codable>(
        endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                endpoint.url,
                method: endpoint.method,
                encoding: endpoint.encoding,
                headers: endpoint.headers
            )
            .validate() // Status code control (200-299)
            .responseDecodable(of: T.self) { response in

                #if DEBUG
                self.logRequest(response: response, endpoint: endpoint)
                #endif
                
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                    
                case .failure(let error):
                    let networkError = self.handleError(response: response, error: error)
                    continuation.resume(throwing: networkError)
                }
            }
        }
    }
    
    /// Multipart/form-data upload request
    /// - Parameters:
    ///   - endpoint: API endpoint
    ///   - multipartFormData: Closure to build multipart form data
    ///   - responseType: Codable response type
    /// - Returns: Response object or Error
    func upload<T: Codable>(
        endpoint: APIEndpoint,
        multipartFormData: @escaping (MultipartFormData) -> Void,
        responseType: T.Type
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            session.upload(
                multipartFormData: multipartFormData,
                to: endpoint.url,
                method: endpoint.method,
                headers: endpoint.headers
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                
                #if DEBUG
                self.logRequest(response: response, endpoint: endpoint)
                #endif
                
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                    
                case .failure(let error):
                    let networkError = self.handleError(response: response, error: error)
                    continuation.resume(throwing: networkError)
                }
            }
        }
    }
    
    // MARK: - Error Handling
    private func handleError(response: AFDataResponse<some Any>, error: AFError) -> NetworkError {
        if let statusCode = response.response?.statusCode {
            let message = response.data.flatMap { String(data: $0, encoding: .utf8) }
            return .serverError(statusCode: statusCode, message: message)
        }

        if case .responseSerializationFailed(let reason) = error {
            if case .decodingFailed(let decodingError) = reason {
                return .decodingError(decodingError)
            }
        }

        return .networkFailure(error)
    }
    
    // MARK: - Debug Logging
    private func logRequest(response: AFDataResponse<some Any>, endpoint: APIEndpoint) {
        print("URL: \(endpoint.url)")
        print("Method: \(endpoint.method.rawValue)")
        print("Status Code: \(response.response?.statusCode ?? 0)")
        
        if let data = response.data, let json = String(data: data, encoding: .utf8) {
            print(" Response: \(json)")
        }
        
        if let error = response.error {
            print(" Error: \(error.localizedDescription)")
        }
    }
}
