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
    
//    init(uid: String) {
    init() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings

//        self.collectionName = self.collectionNamePrefix + uid
//        self.onListen = onListen
        
    }
    
    func initialize(uid: String) {
        self.collectionName = self.collectionNamePrefix + uid
        
        db.collection(self.collectionName!)
            .order(by: "createdAt").limit(toLast: 20)
            .addSnapshotListener(self.addMessage)
    }
    
//    func get() {
//        db.collection(self.collectionName)
//            .order(by: "createdAt").limit(toLast: 20)
//            .getDocuments(completion: self.addMessage)
//    }
    
    private func addMessage(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
        var messages: [ChatMessage] = []
        
        guard let documents = querySnapshot?.documents else {
            print("Error fetching documents: \(error!)")
            return
        }
        
        for document in documents {
            let result = Result {
                try document.data(as: ChatMessage.self)
            }
            switch result {
            case .success(let message):
                if let message = message {
                    messages.append(message)
                }
            case .failure(let error):
                print("Error decoding chatMessage: \(error)")
            }
        }
        
        self.chatMessages = messages
//        self.onListen()
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
