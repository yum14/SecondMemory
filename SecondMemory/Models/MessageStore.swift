//
//  MessageStore.swift
//  SecondMemory
//
//  Created by yum on 2021/07/05.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore


final class MessageStore {
    var chatMessages: [ChatMessage] = []
    {
        didSet {
            if chatMessages.count > 0 {
                self.onListen(chatMessages)
            }
        }
    }
    
    private let db = Firestore.firestore()
    private let usersCollectionName = "users"
    private let messagesCollectionName = "messages"
    private var onListen: ([ChatMessage]) -> Void = { _ in }
    private var uid: String = ""
//    private var firstItemTimestamp: Timestamp? = nil
    
    init() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    func setListener(uid: String, initial: [ChatMessage], onListen: @escaping (_ newValue: [ChatMessage]) -> Void = { _ in }) {
        self.uid = uid
        self.chatMessages = initial
        self.onListen = onListen
        
        if let last = initial.last {
            let modifiedDate = Calendar.current.date(byAdding: .second, value: 1, to: last.createdAt.dateValue())!
            
            db.collection(self.usersCollectionName).document(uid).collection(self.messagesCollectionName)
//                .order(by: "created_at", descending: true)
                .order(by: "created_at")
//                .start(after: [Timestamp(date: dt)])
                .start(after: [Timestamp(date: modifiedDate)])

    //            .limit(toLast: 15)
                .addSnapshotListener(self.snapshotListen)
        } else {
            db.collection(self.usersCollectionName).document(uid).collection(self.messagesCollectionName)
//                .order(by: "created_at", descending: true)
                .order(by: "created_at")
    //            .limit(toLast: 15)
                .addSnapshotListener(self.snapshotListen)
        }
    }

    private func snapshotListen(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
        guard let documents = querySnapshot?.documents else {
            print("Error fetching documents: \(error!)")
            return
        }
        
        if documents.count == 0 {
            return
        }
        
//        let firstItem = self.map(snapshot: documents.first!)
//        guard let firstItem = firstItem else {
//            return
//        }
//        self.firstItemTimestamp = firstItem.createdAt
        
        let newMessages: [ChatMessage] = documents.reduce([]) {
            var newMessages = $0
            if let newMessage = self.map(snapshot: $1) {
                newMessages.append(newMessage)
            }
            return newMessages
        }
        
        self.chatMessages.append(contentsOf: newMessages)
        
//        self.chatMessages = newMessages
    }
    
    
    
//    func fetch() {
//        if self.uid.isEmpty {
//            return
//        }
//
//        db.collection(self.usersCollectionName).document(uid).collection(self.messagesCollectionName)
//            .order(by: "created_at")
//            .end(before: [self.firstItemTimestamp!])
//            .limit(toLast: 15)
//            .getDocuments(completion: { (snapshot, error) in
//
//                guard let documents = snapshot?.documents else {
//                    print("Error fetching documents: \(error!)")
//                    return
//                }
//
//                let newMessages: [ChatMessage] = documents.reduce([]) {
//                    var newMessages = $0
//                    if let newMessage = self.map(snapshot: $1) {
//                        newMessages.append(newMessage)
//                    }
//                    return newMessages
//                }
//
//                if newMessages.count > 0 {
//                    self.firstItemTimestamp = newMessages.first!.createdAt
//                    self.chatMessages.insert(contentsOf: newMessages, at: 0)
//                }
//            })
//
//    }
    
    private func map(snapshot: QueryDocumentSnapshot) -> ChatMessage? {
        let result = Result {
            try snapshot.data(as: ChatMessage.self)
        }
        switch result {
        case .success(let newMessage):
            if let newMessage = newMessage {
                return newMessage
            }
        case .failure(let error):
            print("Error decoding chatMessage: \(error)")
            return nil
            
        }
        return nil
    }
    
    
    
    func add(uid: String, _ message: ChatMessage) {
        do {
            try db.collection(self.usersCollectionName).document(uid).collection(self.messagesCollectionName).document(message.id).setData(from: message)
        } catch let error {
            print("Error writing data: \(error)")
        }
    }    
}
