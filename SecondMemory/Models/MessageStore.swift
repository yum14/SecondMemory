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
    let collectionName: String
    
    init(uid: String) {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings

        self.collectionName = self.collectionNamePrefix + uid
        
        setListener()
    }
    
    func setListener() {
        db.collection(self.collectionName)
            .order(by: "createdAt").limit(toLast: 20)
            .addSnapshotListener(self.onListen)
    }
    
    func get() {
        db.collection(self.collectionName)
            .order(by: "createdAt").limit(toLast: 20)
            .getDocuments(completion: self.onListen)
    }
    
    private func onListen(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
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
    }
    
    func add(_ message: ChatMessage) {
        do {
            try db.collection(self.collectionName).document(message.id).setData(from: message)
        } catch let error {
            print("Error writing data: \(error)")
        }
    }    
}
