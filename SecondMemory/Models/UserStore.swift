//
//  UserStore.swift
//  SecondMemory
//
//  Created by yum on 2021/08/09.
//

import Foundation
import Firebase

class UserStore {
    private let db = Firestore.firestore()
    private let collectionName = "users"

    init() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    func set(_ user: User) {
        do {
            try db.collection(collectionName).document(user.id).setData(from: user)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
