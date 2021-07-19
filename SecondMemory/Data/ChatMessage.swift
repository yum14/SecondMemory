//
//  ChatMessage.swift
//  SecondMemory
//
//  Created by yum on 2021/06/22.
//

import Foundation
import Firebase

struct ChatMessage: Identifiable, Codable {
    var id: String = UUID().uuidString
    let text: String
    let createdAt = Timestamp(date: Date())
    let isMine: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case createdAt
        case isMine = "mine"
    }
}
