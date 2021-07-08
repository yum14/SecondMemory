//
//  FirebaseUIView.swift
//  SecondMemory
//
//  Created by yum on 2021/07/07.
//

import SwiftUI
import FirebaseUI

struct FirebaseUIView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    
    class Coordinator: NSObject, FUIAuthDelegate {
        let parent: FirebaseUIView
        init(_ parent: FirebaseUIView) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let authUI = FUIAuth.defaultAuthUI()!
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(authUI: authUI),
        ]
        authUI.providers = providers
        authUI.delegate = context.coordinator
//        authUI.auth?.addStateDidChangeListener({(auth: Auth, user: User?) in
//            guard let user = user else {
//                print("not user.")
//                return
//            }
//
//            user.getIDToken(completion: {(token: String?, error: Error?) in
//                if let error = error {
//                    print("can't get token. \(error)")
//                    return
//                }
//
//                self.token = token
//            })
//        })
        
        return authUI.authViewController()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}

