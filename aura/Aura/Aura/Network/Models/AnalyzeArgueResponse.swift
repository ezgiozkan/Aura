//
//  AnalyzeArgueResponse.swift
//  Aura
//
//  Created by Ezgi Özkan on 15.01.2026.
//

import Foundation

struct AnalyzeArgueResponse: Codable {
    let winner: String
    let score: Int
    let analysis: String
    let winningPoint: String
    let weakPoint: String
    let advice: String
    
    enum CodingKeys: String, CodingKey {
        case winner
        case score
        case analysis
        case winningPoint = "winning_point"
        case weakPoint = "weak_point"
        case advice
    }
}
