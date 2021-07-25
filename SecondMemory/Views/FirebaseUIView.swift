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
            FUIOAuth.twitterAuthProvider(),
            FUIFacebookAuth(authUI: authUI),
            FUIOAuth.appleAuthProvider()
        ]
        authUI.providers = providers
        authUI.delegate = context.coordinator
        
//        if let bundlePath = Bundle.main.path(forResource: "FirebaseAuthUI", ofType: "strings") {
//            let bundle = Bundle(path: bundlePath)
//            authUI.customStringsBundle = bundle
//        }
        
        return authUI.authViewController()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}

