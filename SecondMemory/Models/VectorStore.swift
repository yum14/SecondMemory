//
//  VectorStore.swift
//  SecondMemory
//
//  Created by yum on 2021/07/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore


class VectorStore: ObservableObject {
    let db = Firestore.firestore()
    let collectionNamePrefix = "vectors_"
    let collectionName: String
    
    init(uid: String) {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings

        self.collectionName = self.collectionNamePrefix + uid
    }
    
    func delete(id: String) {
        db.collection(self.collectionName).document(id).delete()
    }
    
}
