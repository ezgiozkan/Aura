//
//  NetworkResponses.swift
//  Aura
//
//  Created by Ezgi Özkan on 7.01.2026.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let message: String?
    let error: String?
}
