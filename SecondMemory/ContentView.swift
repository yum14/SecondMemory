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
                if !self.authState.initialLoading {
                    if self.authState.isSignin {
                        
                        ChatBotViewContainer(store: MessageStore(uid: self.authState.uid!))
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
