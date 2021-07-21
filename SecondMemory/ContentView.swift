//
//  ContentView.swift
//  SecondMemory
//
//  Created by yum on 2021/06/20.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var authState: FirebaseAuthStateObserver
    @State var isShowSheet = false

    var body: some View {
        NavigationView {
            VStack {
                if authState.isSignin {
                    
                    ChatBotViewContainer(store: MessageStore(uid: self.authState.uid!))
                    
//                    Text("You are logined.")
//                        .padding()
//                    Button("logout") {
//                        try! Auth.auth().signOut()
//                    }
                    
//                    Text(self.authState.uid ?? "")
//                    Text(self.authState.displayName ?? "")
//                    Text(self.authState.photoURL?.absoluteString ?? "")
//                    Text(self.authState.email ?? "")
//
//
//                    NavigationLink("Push to ChatView", destination: ChatBotViewContainer(store: MessageStore(uid: self.authState.uid!)))
//                        .padding()
                }
                else {
                    Text("You are not logged in.")
                        .padding()
                    Button("login") {
                        isShowSheet.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $isShowSheet, content: {
            FirebaseUIView()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
