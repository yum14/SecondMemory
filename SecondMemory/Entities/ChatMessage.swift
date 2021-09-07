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
    
    init(id: String = UUID().uuidString, type: ChatType, contents: [ChatMessageContent], createdAt: Date = Date()) {
        self.id = id
        self.type = type.rawValue
        self.contents = contents
        self.createdAt = Timestamp(date: createdAt)
    }
    
    enum ChatType: String {
        case mine = "mine"
        case bot = "bot"
        case search = "search"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case contents
        case createdAt = "created_at"
    }
}

extension ChatMessage {
    func toCache(uid: String) -> ChatMessageCache {
        return ChatMessageCache(id: self.id, uid: uid, type: self.type, contents: self.contents.map { $0.toCache() }, createdAt: DateUtility.toString(date: self.createdAt.dateValue()))
    }
}

struct ChatMessageContent: Identifiable, Codable {
    var id: String = UUID().uuidString
    var text: String
    var score: Float? = nil
}

extension ChatMessageContent {
    func toCache() -> ChatMessageContentCache {
        return ChatMessageContentCache(id: self.id, text: self.text, score: self.score == nil ? "" : String(self.score!))
    }
}
