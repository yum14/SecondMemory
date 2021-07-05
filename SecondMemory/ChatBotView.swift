//
//  ChatBotView.swift
//  SecondMemory
//
//  Created by yum on 2021/07/02.
//

import SwiftUI

struct ChatBotView: View {
    
    @State private var text: String = ""
    
    @State private var objectDescription: String?
    
    @State private var height: CGFloat = 36
    @State private var resignFirstResponder: Bool = false
    @State private var scrollViewProxy: ScrollViewProxy?
    
    // TODO: 仮データ
    @State private var messages = [
        ChatMessage(id: "a", text: "テキスト1", isMine: false),
        ChatMessage(id: "a", text: "テキスト2", isMine: false),
        ChatMessage(id: "b", text: "テキスト3", isMine: true),
        ChatMessage(id: "c", text: "テキスト4", isMine: true),]
    
    var body: some View {
        VStack {
            ChatListView(messages: self.messages,
                         scrollViewProxy: self.$scrollViewProxy)
            
            
            InputChatView(text: self.$text) {
                
                if !self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.messages.append(ChatMessage(id: "add" + String(messages.count), text: self.text, isMine: true))
                    
                    
                    guard let proxy = self.scrollViewProxy,
                          let message = self.messages.last else {
                        return
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        withAnimation {
                            //一番下にアニメーションする
                            proxy.scrollTo(message.id, anchor: .bottom)
                        }
                    })
                    
                }
                
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
        }
    }
}

struct ChatBotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView()
    }
}

public extension Binding where Value: Equatable {
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy {
                    source.wrappedValue = nil
                }
                else {
                    source.wrappedValue = newValue
                }
        })
    }
}
