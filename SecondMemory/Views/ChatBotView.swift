//
//  ChatBotView.swift
//  SecondMemory
//
//  Created by yum on 2021/07/02.
//

import SwiftUI

struct ChatBotView: View {
    var idToken: String
    var messages: [ChatMessage]
    var addChatMessage: (ChatMessage) -> Void = { _ in }
    var deleteVector: (String) -> Void = { _ in }
  
    var fetchData: () -> Void = {}
    
    @State var text: String = ""
    @State private var firstAppear = true
    @State private var height: CGFloat = 36
    @Binding var scrollViewProxy: ScrollViewProxy?
    
    @State var searching = false
    
    
    var body: some View {
        VStack {
            ChatListView(messages: self.messages,
                         scrollViewProxy: self.$scrollViewProxy,
                         deleteVector: self.deleteVector,
                         onListItemAppear: self.onListItemAppear)
            
            HStack(alignment: .bottom, spacing: 0) {
                Button(action: {
                    self.onBotIconTapped()
                }) {
                    BotImageView(width: 44, height: 44)
                        .padding(.trailing, 8)
                }

                InputChatView(text: self.$text,
                              searching: self.searching,
                              onCommit: {
                                self.onCommit()
                                
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
    }
    
    func onBotIconTapped() -> Void {
        let text = "検索ワードをチャットしてけろ。"
        
        // firestoreにデータ追加
        let doc = ChatMessage(type: .bot, contents: [ChatMessageContent(text: text)])
        self.addChatMessage(doc)
        self.searching = true        
        self.text = "> "
    }
    
    
    func onCommit() -> Void {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        
        let contentId = UUID().uuidString
        // firestoreにデータ追加
        let doc = ChatMessage(type: .mine, contents: [ChatMessageContent(id: contentId, text: self.text)])
        self.addChatMessage(doc)
        
        
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
                            
                            print("word: \(searchWord)")
                            for result in response.result {
                                print("id: \(result.id), score: \(result.score)")
                            }
                            
                            let doc = ChatMessage(type: .search, contents: response.result.map { ChatMessageContent(id: $0.id, text: $0.sentence, score: $0.score) })
                            
                            self.addChatMessage(doc)
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
                
                let content = VectorEncodeRequest(id: contentId, sentence: self.text)
                
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
    
    func onListItemAppear(item: ChatMessage) -> Void {
        if self.messages.isFirstItem(item) {
            // 新しいページデータを取得
            self.fetchData()
        }
    }
    
}

struct ChatBotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView(idToken: "", messages: [ChatMessage(id: "id", type: .mine, contents: [ChatMessageContent(id: "id", text: "test1")])], scrollViewProxy: .constant(nil))
    }
}
