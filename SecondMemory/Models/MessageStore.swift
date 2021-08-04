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


class MessageStore: ObservableObject {
    
    @Published var chatMessages = [ChatMessage]()
    
    let db = Firestore.firestore()
    let collectionNamePrefix = "messages_"
    var collectionName: String?
    
    
    var firstItemTimestamp: Timestamp? = nil
    
    
    init() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        
    }
    
    func initialize(uid: String) {
        self.collectionName = self.collectionNamePrefix + uid
        
        db.collection(self.collectionName!)
            .order(by: "createdAt")
            .limit(toLast: 15)
            .addSnapshotListener(self.onListen)
    }
    
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
        db.collection(self.collectionName!)
            .order(by: "createdAt")
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
        guard let collectionName = self.collectionName else {
            return
        }
        
        do {
            try db.collection(collectionName).document(message.id).setData(from: message)
        } catch let error {
            print("Error writing data: \(error)")
        }
    }    
}
