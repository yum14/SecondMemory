//
//  ChatMessage.swift
//  SecondMemory
//
//  Created by yum on 2021/06/22.
//

import Foundation

class ChatMessage {
    init(id: String, text: String, isMine: Bool) {
        self.id  = id
        self.text = text
        self.isMine = isMine
    }
    
    var id: String
    var text: String
    var isMine: Bool
}
