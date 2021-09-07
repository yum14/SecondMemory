//
//  MessageCacheStore.swift
//  SecondMemory
//
//  Created by yum on 2021/08/22.
//

import Foundation
import RealmSwift

class MessageCacheStore {
    var messages: [ChatMessageCache] = []
    {
        didSet {
            if messages.count > 0 {
                self.onListen(messages)
            }
        }
    }
    private var notificationTokens: [NotificationToken] = []
    private var realmObject: ChatMessageCaches
    private var onListen: ([ChatMessageCache]) -> Void = { _ in }
    
    private var uid: String = ""
    
    init() {
        let realm = RealmHelper.createRealm()
        var obj = realm.object(ofType: ChatMessageCaches.self, forPrimaryKey: 0)
        if obj == nil {
            obj = try! realm.write{ realm.create(ChatMessageCaches.self, value: ChatMessageCaches())}
        }
        self.realmObject = obj!
    }
    
//    func setListener(uid: String, onListen: @escaping (_ newValue: [ChatMessageCache]) -> Void = { _ in }) {
//        self.uid = uid
//        let realm = RealmHelper.createRealm()
//        var messages = realm.object(ofType: ChatMessageCaches.self, forPrimaryKey: 0)
//        if messages == nil {
//            messages = try! realm.write{ realm.create(ChatMessageCaches.self, value: ChatMessageCaches())}
//        }
//        self.realmObject = messages!
//
//        self.messages = self.realmObject.messages.freeze().map { $0 }.filter({ $0.uid == self.uid })
//
//        notificationTokens.append(self.realmObject.messages.observe { change in
//            switch change {
//            case let .initial(results):
//                self.messages = results.freeze().map { $0 }.filter({ $0.uid == self.uid })
//            case let .update(results, _, _, _):
//                self.messages = results.freeze().map { $0 }.filter({ $0.uid == self.uid })
//            case let .error(error):
//                print(error.localizedDescription)
//            }
//        })
//    }

    func getAll(uid: String) -> [ChatMessageCache] {
        return self.realmObject.messages.freeze().map { $0 }.filter({ $0.uid == uid })
    }

    func add(_ newMessage: ChatMessageCache) {
        let realm = RealmHelper.createRealm()
        try! realm.write {
            self.realmObject.messages.append(newMessage)
        }
    }

    func add(_ newMessages: [ChatMessageCache]) {
        let realm = RealmHelper.createRealm()
        try! realm.write {
            self.realmObject.messages.append(objectsIn: newMessages)
        }
    }

    func removeOldItems(to: Int) {
        let deleteCount = self.messages.count - to
        if deleteCount <= 0 {
            return
        }

        let ids = self.messages
            .sorted { $1.createdAt < $0.createdAt }
            .enumerated()
            .filter { $0.0 <= deleteCount }
            .map { $1.id }

        let realm = RealmHelper.createRealm()
        try! realm.write {
            for id in ids {
                guard let index = self.realmObject.messages.firstIndex(where: { $0.id == id }) else {
                    continue
                }

                self.realmObject.messages.remove(at: index)
            }
        }
    }
}


