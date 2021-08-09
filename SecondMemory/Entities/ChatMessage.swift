//
//  ChatMessage.swift
//  SecondMemory
//
//  Created by yum on 2021/06/22.
//

import Foundation
import Firebase

struct ChatMessage: Identifiable, Codable {
    let id: String
    let type: String
    let contents: [ChatMessageContent]
    let createdAt: Timestamp

    init(id: String = UUID().uuidString, type: ChatType, contents: [ChatMessageContent], createdAt: Timestamp = Timestamp(date: Date())) {
        self.id = id
        self.type = type.rawValue
        self.contents = contents
        self.createdAt = createdAt
    }
    
    enum ChatType: String {
        case mine
        case bot
        case search
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case contents
        case createdAt = "created_at"
    }
}

struct ChatMessageContent: Identifiable, Codable {
    var id: String = UUID().uuidString
    var text: String
    var score: Float? = nil
}
