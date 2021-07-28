//
//  ChatBotViewContainer.swift
//  SecondMemory
//
//  Created by yum on 2021/07/18.
//

import SwiftUI

struct ChatBotViewContainer: View {
    @EnvironmentObject var messageStore: MessageStore
    @EnvironmentObject var vectorStore: VectorStore
    @EnvironmentObject var authState: FirebaseAuthStateObserver
    @State var scrollViewProxy: ScrollViewProxy?

    var body: some View {
        ChatBotView(idToken: self.authState.token ?? "", messages: self.messageStore.chatMessages, addChatMessage: self.addChatMessage, deleteVector: self.deleteVector, scrollViewProxy: self.$scrollViewProxy)
            
            
            .onReceive(messageStore.$chatMessages, perform: { value in
                if value.count > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        withAnimation {
                            // 一番下にスクロールする
                            self.scrollViewProxy?.scrollTo(value.count - 1, anchor: .bottom)
                            
                        }
                    })
                }
            })
    }
    
    func addChatMessage(value: ChatMessage) -> Void {
        self.messageStore.add(value)
    }
    
    func deleteVector(id: String) -> Void {
        self.vectorStore.delete(id: id)
    }
}
