//
//  ChatMessage.swift
//  SecondMemory
//
//  Created by yum on 2021/06/22.
//

import Foundation
import Firebase

struct ChatMessage: Codable {
    let text: String
    let createdAt = Timestamp(date: Date())
    let isMine: Bool
    
    enum CodingKeys: String, CodingKey {
        case text
        case createdAt
        case isMine = "mine"
    }
}
