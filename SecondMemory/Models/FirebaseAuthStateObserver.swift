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
    @Published var initialLoading: Bool = true
    
    private let userStore = UserStore()
    
    private var listener: AuthStateDidChangeListenerHandle!

    init() {
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else {
                print("sign-out")
                self.isSignin = false
                self.initialLoading = false
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
            
            let setUser = User(id: user.uid, displayName: user.displayName, email: user.email, photoUrl: user.photoURL?.absoluteString)
            self.userStore.set(setUser)
            
            self.isSignin = true
            self.initialLoading = false
        }
    }

    deinit {
        Auth.auth().removeStateDidChangeListener(listener)
    }

}
