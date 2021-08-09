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


class MessageStore {
    
    var chatMessages: [ChatMessage] = []
    {
        didSet {
            if chatMessages.count > 0 && chatMessages.count != oldValue.count {
                self.didSet(chatMessages)
            }
        }
    }
    
    private let db = Firestore.firestore()
    
    private let usersCollectionName = "users"
    private let messagesCollectionName = "messages"
    var didSet: ([ChatMessage]) -> Void = { _ in }
    
    private let uid: String
    
    var firstItemTimestamp: Timestamp? = nil
    
    
    init(uid: String, didSet: @escaping (_ newValue: [ChatMessage]) -> Void = { _ in }) {
        self.uid = uid
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings

        db.collection(self.usersCollectionName).document(uid).collection(self.messagesCollectionName)
            .order(by: "created_at")
            .limit(toLast: 15)
            .addSnapshotListener(self.onListen)
    }
    
//    func initialize(uid: String) {
//        self.collectionName = self.collectionNamePrefix + uid
//
//        db.collection(self.collectionName!)
//            .order(by: "createdAt")
//            .limit(toLast: 15)
//            .addSnapshotListener(self.onListen)
//    }
    
    private func onListen(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
        guard let documents = querySnapshot?.documents else {
            print("Error fetching documents: \(error!)")
            return
        }
        
        if documents.count == 0 {
            return
        }
        
        let firstItem = self.map(snapshot: documents.first!)
        guard let firstItem = firstItem else {
            return
        }
        self.firstItemTimestamp = firstItem.createdAt
        
        
        let newMessages: [ChatMessage] = documents.reduce([]) {
            var newMessages = $0
            if let newMessage = self.map(snapshot: $1) {
                newMessages.append(newMessage)
            }
            return newMessages
        }

        self.chatMessages = newMessages
    }
    
    
    
    func fetch() {
        db.collection(self.usersCollectionName).document(uid).collection(self.messagesCollectionName)
            .order(by: "created_at")
            .end(before: [self.firstItemTimestamp!])
            .limit(toLast: 15)
            .getDocuments(completion: { (snapshot, error) in
                
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }

                let newMessages: [ChatMessage] = documents.reduce([]) {
                    var newMessages = $0
                    if let newMessage = self.map(snapshot: $1) {
                        newMessages.append(newMessage)
                    }
                    return newMessages
                }
                
                if newMessages.count > 0 {
                    self.firstItemTimestamp = newMessages.first!.createdAt
                    self.chatMessages.insert(contentsOf: newMessages, at: 0)
                }
            })
        
    }
    
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
    
    
    
    func add(_ message: ChatMessage) {
        do {
            try db.collection(self.usersCollectionName).document(uid).collection(self.messagesCollectionName).document(message.id).setData(from: message)
        } catch let error {
            print("Error writing data: \(error)")
        }
    }    
}
