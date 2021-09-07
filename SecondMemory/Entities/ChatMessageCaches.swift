//
//  ChatMessageCaches.swift
//  SecondMemory
//
//  Created by yum on 2021/08/21.
//

import Foundation
import RealmSwift

class ChatMessageCaches: Object, Identifiable {
    @objc dynamic var id: Int = 0
    let messages = List<ChatMessageCache>()
    
    override init() {}
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
