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
    @State var chatListViewPresenter = ChatListViewPresenter()
    var loginViewPresenter = LoginViewPresenter()
    
    var body: some View {
        NavigationView {
            VStack {
                if !self.authState.initialLoading {
                    if self.authState.isSignin, let uid = self.authState.uid, let token = self.authState.token {
                        
                        ChatListView(presenter: self.chatListViewPresenter,
                                     uid: uid,
                                     idToken: token)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("ログアウト") {
                                        do {
                                            try Auth.auth().signOut()
                                            
                                            // presenter初期化
                                            self.chatListViewPresenter = ChatListViewPresenter()
                                            
                                        } catch let error {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            }                    }
                    else {
                        LoginView(presenter: self.loginViewPresenter)
                    }
                } else {
                    Text("Loading.....")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
