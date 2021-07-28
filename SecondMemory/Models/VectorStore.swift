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
    var collectionName: String?
    
//    init(uid: String) {
    init() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings

//        self.collectionName = self.collectionNamePrefix + uid
    }
    
    func initialize(uid: String) {
        self.collectionName = self.collectionNamePrefix + uid
    }
    
    func delete(id: String) {
        guard let collectionName = self.collectionName else {
            return
        }
        db.collection(collectionName).document(id).delete()
    }
    
}
