//
//  ChatBotViewContainer.swift
//  SecondMemory
//
//  Created by yum on 2021/07/18.
//

import SwiftUI

struct ChatBotViewContainer: View {
    @ObservedObject var messageStore: MessageStore
    @ObservedObject var vectorStore: VectorStore
    @EnvironmentObject var authState: FirebaseAuthStateObserver
    
    var body: some View {
        ChatBotView(idToken: self.authState.token ?? "", messages: self.messageStore.chatMessages, addChatMessage: self.addChatMessage, deleteVector: self.deleteVector)
    }
    
    func addChatMessage(value: ChatMessage) -> Void {
        self.messageStore.add(value)
    }
    
    func deleteVector(id: String) -> Void {
        self.vectorStore.delete(id: id)
    }
}
