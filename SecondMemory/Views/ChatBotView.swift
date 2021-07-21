//
//  ChatBotView.swift
//  SecondMemory
//
//  Created by yum on 2021/07/02.
//

import SwiftUI

struct ChatBotView: View {
    let idToken: String
    let messages: [ChatMessage]
    let addChatMessage: ((ChatMessage) -> Void)?

    @State var text: String = ""
    @State private var firstAppear = true
    @State private var height: CGFloat = 36
//    @State private var becomeFirstResponder: Bool = false
    @State private var scrollViewProxy: ScrollViewProxy?
    
    @State var searching = false
    
    var body: some View {
        VStack {
            ChatListView(messages: self.messages, scrollViewProxy: self.$scrollViewProxy)
            
            HStack(alignment: .bottom, spacing: 0) {
                Button(action: {
                    self.onBotIconTapped()
                    self.scrollBottom()
                }) {
                    BotImageView(width: 44, height: 44)
                        .padding(.trailing, 8)
                }

                InputChatView(text: self.$text,
                              searching: self.searching,
                              onCommit: {
                                self.onCommit()
                                self.scrollBottom()
//                                self.becomeFirstResponder = false
                                
                                if self.searching {
                                    self.searching.toggle()
                                }
                              },
                              onDismiss: {
                                if self.searching {
                                    self.searching.toggle()
                                }
                              })
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
        }
        .onAppear {
            if self.firstAppear {
                self.scrollBottom()

                self.firstAppear.toggle()
            }
        }
    }
    
    func scrollBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            withAnimation {
                // 一番下にアニメーションする
                self.scrollViewProxy?.scrollTo(self.messages.count, anchor: .bottom)
                
            }
        })
    }
    
    func onBotIconTapped() -> Void {
        let text = "検索ワードをチャットしてけろ。"
        
        // firestoreにデータ追加
        let doc = ChatMessage(text: text, isMine: false)
        self.addChatMessage?(doc)
        self.searching = true        
        self.text = "> "
    }
    
    
    func onCommit() -> Void {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        
        let id = UUID().uuidString
        
        // firestoreにデータ追加
        let doc = ChatMessage(id: id, text: self.text, isMine: true)
        self.addChatMessage?(doc)
        
        
        if self.text.hasPrefix("> ") {
            
            let searchWord = String(self.text.suffix(self.text.count - 2))
            
            let model = CdistApiClient(idToken: self.idToken)
            
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
                            
                            // firestoreにデータ追加
                            let doc = ChatMessage(text: response.result.map { $0.sentence }.joined(separator: "\n"), isMine: false)
                            
                            self.addChatMessage?(doc)
                        }
                    }
                    
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            
        } else {
            
            // APIにベクトル化&データ追加リクエスト
            let model = VectorEncodeApiClient(idToken: self.idToken)
            
            do {
                
                let content = VectorEncodeRequest(id: id, sentence: self.text)
                
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
    
}

struct ChatBotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView(idToken: "", messages: [ChatMessage(id: "id", text: "test", isMine: true)], addChatMessage: nil)
    }
}
