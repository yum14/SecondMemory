//
//  VectorStore.swift
//  SecondMemory
//
//  Created by yum on 2021/07/24.
//

import Foundation
import Firebase

final class VectorStore: ObservableObject {
    static let shared = VectorStore()
    
    let db = Firestore.firestore()
    
    private let usersCollectionName = "users"
    private let vectorsCollectionName = "vectors"
    
    private init() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    func delete(uid: String, id: String) {
        db.collection(self.usersCollectionName).document(uid).collection(self.vectorsCollectionName).document(id).delete()
    }
    
}
