//
//  FirebaseAuthStateObserver.swift
//  SecondMemory
//
//  Created by yum on 2021/07/07.
//

import Firebase

class FirebaseAuthStateObserver: ObservableObject {
    @Published var isSignin: Bool = false
    @Published var token: String?
    @Published var uid: String?
    @Published var displayName: String?
    @Published var email: String?
    @Published var photoURL: URL?
    
    private var listener: AuthStateDidChangeListenerHandle!

    init() {
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else {
                print("sign-out")
                self.isSignin = false
                return
            }
            
            self.uid = user.uid
            self.displayName = user.displayName
            self.email = user.email
            self.photoURL = user.photoURL
            
            user.getIDTokenForcingRefresh(true) {(token: String?, error: Error?) in
                if let error = error {
                    print("can't get token. \(error)")
                    return
                }
                
                self.token = token
            }
            
            print("sign-in")
            self.isSignin = true
        }
    }

    deinit {
        Auth.auth().removeStateDidChangeListener(listener)
    }

}
