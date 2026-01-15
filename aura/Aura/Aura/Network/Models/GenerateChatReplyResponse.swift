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
    
    /// Sadece reply text'lerini döndürür
    var replyTexts: [String] {
        replies.map(\.text)
    }
}

struct ChatReply: Codable, Sendable, Equatable {
    let tone: String
    let text: String
    let explanation: String
}
