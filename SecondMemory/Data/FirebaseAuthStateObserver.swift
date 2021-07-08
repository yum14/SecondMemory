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
    @Published var authUser: AuthUser?
    private var listener: AuthStateDidChangeListenerHandle!

    init() {
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.authUser = AuthUser(uid: user.uid, displayName: user.displayName, email: user.email, photoURL: user.photoURL)
                user.getIDToken(completion: {(token: String?, error: Error?) in
                    if let error = error {
                        print("can't get token. \(error)")
                        return
                    }
                    
                    self.token = token
                })
                
                print("sign-in")
                self.isSignin = true
            } else {
                print("sign-out")
                self.isSignin = false
            }
        }
    }

    deinit {
        Auth.auth().removeStateDidChangeListener(listener)
    }

}
