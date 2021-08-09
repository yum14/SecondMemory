//
//  VectorStore.swift
//  SecondMemory
//
//  Created by yum on 2021/07/24.
//

import Foundation
import Firebase

class VectorStore: ObservableObject {
    let db = Firestore.firestore()
    
    private let usersCollectionName = "users"
    private let vectorsCollectionName = "vectors"
    private let uid: String
    
    init(uid: String) {
        self.uid = uid
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    func delete(id: String) {
        db.collection(self.usersCollectionName).document(self.uid).collection(self.vectorsCollectionName).document(id).delete()
    }
    
}
