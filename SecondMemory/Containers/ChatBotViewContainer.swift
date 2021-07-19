//
//  ChatBotViewContainer.swift
//  SecondMemory
//
//  Created by yum on 2021/07/18.
//

import SwiftUI

struct ChatBotViewContainer: View {
    @ObservedObject var store: MessageStore
    @EnvironmentObject var authState: FirebaseAuthStateObserver
    
    @State var text = ""
    
    var body: some View {
        ChatBotView(messages: self.store.chatMessages, onCommit: self.onCommit, onBotIconTapped: self.onBotIconTapped, text: self.$text)
    }
    
    func onCommit(text: String) -> Void {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        
        let id = UUID().uuidString
        
        // firestoreにデータ追加
        let doc = ChatMessage(id: id, text: text, isMine: true)
        self.store.add(doc)
        
        // APIにベクトル化&データ追加リクエスト
        guard let idToken = self.authState.token else {
            return
        }
        
        if text.hasPrefix("> ") {
            
            let searchWord = String(text.suffix(text.count - 2))
            
            let model = CdistApiClient(idToken: idToken)
            
            do {
                try model.get(search: searchWord) {(status: Int?, response: CdistResponse?, error: Error?) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    guard let status = status else {
                        print("no http statuscode.")
                        return
                    }
                    
                    print("HTTP status: \(String(status))")
                    
                    if let response = response {
                        if response.errors.count > 0 {
                            for error in response.errors {
                                print("errorMessage: \(error.message)")
                            }
                        } else {
                            for item in response.result {
                                // firestoreにデータ追加
                                let doc = ChatMessage(text: item.sentence, isMine: false)
                                self.store.add(doc)
                            }
                        }
                    }
                    
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            
        } else {
            
            
            let model = VectorEncodeApiClient(idToken: idToken)
            
            do {
                
                let content = VectorEncodeRequest(id: id, sentence: text)
                
                try model.post(content: content) {(status: Int?, response: VectorEncodeResponse?, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    guard let status = status else {
                        print("no http statuscode.")
                        return
                    }
                    
                    print("HTTP status: \(String(status))")
                    
                    if let response = response {
                        print("id: \(response.id)")
                        
                        for error in response.errors {
                            print("errorMessage: \(error.message)")
                        }
                    }
                }
            } catch let error{
                print(error.localizedDescription)
            }
        }
        
    }
    
    func onBotIconTapped() -> Void {
        let text = "検索ワードをチャットしてけろ。"
        
        // firestoreにデータ追加
        let doc = ChatMessage(text: text, isMine: false)
        self.store.add(doc)
        
        self.text = "> "
    }
}
