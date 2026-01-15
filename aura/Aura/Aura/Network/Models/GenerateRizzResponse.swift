//
//  GenerateRizzResponse.swift
//  Aura
//
//  Created by Ezgi Özkan on 8.01.2026.
//

import Foundation

struct GenerateRizzResponse: Codable {
    let imageAnalysis: String
    let options: [RizzOption]

    enum CodingKeys: String, CodingKey {
        case imageAnalysis = "image_analysis"
        case options
    }
}

struct RizzOption: Codable {
    let text: String
    let explanation: String
}
