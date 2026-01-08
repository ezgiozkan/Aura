//
//  CheckAuraResponse.swift
//  Aura
//
//  Created by Ezgi Özkan on 8.01.2026.
//

import Foundation

struct CheckAuraResponse: Codable {
    let score: Int
    let title: String
    let description: String
    let redFlags: [String]
    let greenFlags: [String]
    let verdict: String

    enum CodingKeys: String, CodingKey {
        case score
        case title
        case description
        case redFlags = "red_flags"
        case greenFlags = "green_flags"
        case verdict
    }
}
