//
//  ChatListView.swift
//  SecondMemory
//
//  Created by yum on 2021/06/22.
//

import SwiftUI

struct ChatListView: View {
    var messages: [ChatMessage]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(self.messages.indices, id: \.self) { index in
                    
                    let message = self.messages[index]
                    
                    Group {
                        if message.isMine {
                            MyChatView(text: message.text)
                                .layoutPriority(1)
                                .padding(.leading, 60)
                                .padding(.trailing, 12)
                                .padding(.bottom, 12)
                        } else {
                            BotChatView(text: message.text)
                                .layoutPriority(1)
                                .padding(.trailing, 50)
                                .padding(.leading, 4)
                                .padding(.bottom, 12)
                        }
                    }.id(index)
                }
            }
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let messages = [ChatMessage(id: "a", text: "こんちゃ", isMine: false),
                        ChatMessage(id: "a", text: "何か御用？", isMine: false),
                        ChatMessage(id: "a", text: "今日のお買い物　にんじん、ジャガイモ、豚肉", isMine: true),
                        ChatMessage(id: "a", text: "あとカレールーも", isMine: true)]
        
        return ChatListView(messages: messages)
    }
}
