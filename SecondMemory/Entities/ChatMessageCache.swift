//
//  ChatMessageCache.swift
//  SecondMemory
//
//  Created by yum on 2021/08/21.
//

import Foundation
import RealmSwift

class ChatMessageCache: Object, Identifiable {
    @objc dynamic var id: String = ""
    @objc dynamic var uid: String = ""
    @objc dynamic var type: String = ""
    let contents = List<ChatMessageContentCache>()
    @objc dynamic var createdAt: String = ""
    
    override init() {}
    
    convenience init(id: String, uid: String, type: String, contents: [ChatMessageContentCache], createdAt: String) {
        self.init()
        
        self.id = id
        self.uid = uid
        self.type = type
        self.contents.append(objectsIn: contents)
        self.createdAt = createdAt
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension ChatMessageCache {
    func toContent() -> ChatMessage {
        return ChatMessage(id: self.id, type: ChatMessage.ChatType(rawValue: self.type)!, contents: self.contents.map { $0.toContent() }, createdAt: self.createdAt.isEmpty ? Date() : DateUtility.toDate(dateString: self.createdAt))
    }
}

class ChatMessageContentCache: Object, Identifiable {
    @objc dynamic var id: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var score: String = ""
    
    override init() {}
    
    convenience init(id: String, text: String, score: String) {
        self.init()
        
        self.id = id
        self.text = text
        self.score = score
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension ChatMessageContentCache {
    func toContent() -> ChatMessageContent {
        return ChatMessageContent (id: self.id, text: self.text, score: self.score.isEmpty ? nil: Float(self.score))
    }
}
