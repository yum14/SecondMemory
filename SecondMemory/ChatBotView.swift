//
//  ChatBotView.swift
//  SecondMemory
//
//  Created by yum on 2021/07/02.
//

import SwiftUI
import Firebase
//import FirebaseFirestoreSwift
import FirebaseFirestore

struct ChatBotView: View {
    
    @State private var firstAppear = true
    @State private var text: String = ""
    @State private var height: CGFloat = 36
    @State private var resignFirstResponder: Bool = false
    @State private var scrollViewProxy: ScrollViewProxy?
    @ObservedObject private var store = MessageStore()
    
    var body: some View {
        VStack {
            ChatListView(messages: self.store.chatMessages,
                         scrollViewProxy: self.$scrollViewProxy)
            
            InputChatView(text: self.$text) {

                if !self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    
                    // firestoreにデータ追加
                    let doc = ChatMessage(text: self.text, isMine: true)
                    self.store.add(doc)
                     
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        withAnimation {
                            // 一番下にアニメーションする
                            self.scrollViewProxy?.scrollTo(self.store.chatMessages.count - 1, anchor: .bottom)
                            
                        }
                    })
                }
                
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
        }
        .onAppear {
            if self.firstAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    // 一番下にアニメーションする
                    self.scrollViewProxy?.scrollTo(self.store.chatMessages.count - 1, anchor: .bottom)
                })
            }
        }
    }
}

struct ChatBotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView()
    }
}

