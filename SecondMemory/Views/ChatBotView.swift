//
//  ChatBotView.swift
//  SecondMemory
//
//  Created by yum on 2021/07/02.
//

import SwiftUI

struct ChatBotView: View {
    let messages: [ChatMessage]
    let onCommit: (String) -> Void
    let onBotIconTapped: () -> Void

    @Binding var text: String
    @State private var firstAppear = true
    @State private var height: CGFloat = 36
    @State private var resignFirstResponder: Bool = false
    @State private var scrollViewProxy: ScrollViewProxy?
    
    
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
                

                InputChatView(text: self.$text, onCommit: {
                    self.onCommit(self.text)
                    
                    self.scrollBottom()
                })
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
        }
        .onAppear {
            if self.firstAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    // 一番下にアニメーションする
                    self.scrollViewProxy?.scrollTo(self.messages.count - 1, anchor: .bottom)
                })
                
                self.firstAppear.toggle()
            }
        }
    }
    
    func scrollBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            withAnimation {
                // 一番下にアニメーションする
                self.scrollViewProxy?.scrollTo(self.messages.count, anchor: .bottom)
                
            }
        })
    }
}

struct ChatBotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView(messages: [ChatMessage(id: "id", text: "test", isMine: true)], onCommit: {_ in }, onBotIconTapped: {}, text: .constant(""))
    }
}
