//
//  GenerateChatReplyResponse.swift
//  Aura
//
//  Created by Ezgi Özkan on 12.01.2026.
//

import Foundation

struct GenerateChatReplyResponse: Codable, Sendable {
    let analysis: String
    let replies: [ChatReply]
}

struct ChatReply: Codable, Sendable {
    let tone: String
    let text: String
    let explanation: String
}
