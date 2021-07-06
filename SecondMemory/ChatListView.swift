//
//  ChatListView.swift
//  SecondMemory
//
//  Created by yum on 2021/06/22.
//

import SwiftUI
import Firebase

struct ChatListView: View {
    var messages: [ChatMessage]
    @Binding var scrollViewProxy: ScrollViewProxy?
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(self.messages.indices, id: \.self) { index in
                    
                    let message = self.messages[index]
                    
                    Group {
                        if message.isMine {
                            MyMessageView(text: message.text)
                                .layoutPriority(1)
                                .padding(.leading, 60)
                                .padding(.trailing, 12)
                                .padding(.bottom, 12)
                        } else {
                            BotMessageView(text: message.text)
                                .layoutPriority(1)
                                .padding(.trailing, 50)
                                .padding(.leading, 4)
                                .padding(.bottom, 12)
                        }
                    }.id(index)
                }
            }
            .onAppear {
                 self.scrollViewProxy = proxy
             }
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let messages = [ChatMessage(text: "こんちゃ", isMine: false),
                        ChatMessage(text: "何か御用？", isMine: false),
                        ChatMessage(text: "今日のお買い物　にんじん、ジャガイモ、豚肉", isMine: true),
                        ChatMessage(text: "あとカレールーも", isMine: true)]
        
        return ChatListView(messages: messages, scrollViewProxy: .constant(nil))
    }
}
