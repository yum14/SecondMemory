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
    
    var body: some View {
        ChatBotView(idToken: self.authState.token ?? "", messages: self.store.chatMessages, addChatMessage: self.addChatMessage)
    }
    
    func addChatMessage(value: ChatMessage) -> Void {
        self.store.add(value)
    }
    

}
