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
//    @EnvironmentObject var messageStore: MessageStore
//    @EnvironmentObject var vectorStore: VectorStore
    @State var isShowSheet = false
    @State var text = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if !self.authState.initialLoading {
                    if self.authState.isSignin {
                        ChatListView(presenter: ChatListViewPresenter(uid: self.authState.uid!, idToken: self.authState.token ?? ""))
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("ログアウト") {
                                        do {
                                            try Auth.auth().signOut()
                                        } catch let error {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            }
                    }
                    else {
                        Text("You are not logged in.")
                            .padding()
                        Button("login") {
                            isShowSheet.toggle()
                        }
                    }
                } else {
                    Text("Loading.....")
                }
            }
            .onChange(of: authState.uid, perform: { value in
                guard let uid = value else {
                    return
                }
                
//                self.messageStore.initialize(uid: uid)
//                self.vectorStore.initialize(uid: uid)
            })
            .navigationBarTitleDisplayMode(.inline)
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
