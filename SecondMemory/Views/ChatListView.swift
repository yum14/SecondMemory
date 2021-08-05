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
    var deleteChatMessage: (String) -> Void = { _ in }
    var deleteVector: (String) -> Void = { _ in }
    var onListItemAppear: (ChatMessage) -> Void = { _ in }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(self.messages.indices, id: \.self) { index in
                        let message = self.messages[index]
                        Group {
                            if message.type == ChatMessage.ChatType.mine.rawValue {
                                MyMessageView(text: message.contents[0].text)
                                    .layoutPriority(1)
                                    .padding(.leading, 60)
                                    .padding(.trailing, 12)
                                    .padding(.bottom, 12)
                            } else if message.type == ChatMessage.ChatType.bot.rawValue {
                                BotMessageView(text: message.contents[0].text)
                                    .layoutPriority(1)
                                    .padding(.trailing, 50)
                                    .padding(.leading, 4)
                                    .padding(.bottom, 12)
                            } else {
                                BotSearchResultView(messages: message.contents,
                                                    onMovePressed: { _ in },
                                                    onDeletePressed: self.deleteVector)
                                    .layoutPriority(1)
                                    .padding(.trailing, 50)
                                    .padding(.leading, 4)
                                    .padding(.bottom, 12)
                            }
                        }
                        .id(index)
                        .onAppear {
                            self.onListItemAppear(message)
                        }
                    }
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
        
        let messages = [ChatMessage(type: .bot, contents: [ChatMessageContent(text: "こんちゃ")]),
                        ChatMessage(type: .bot, contents: [ChatMessageContent(text: "何か御用？")]),
                        ChatMessage(type: .mine, contents: [ChatMessageContent(text: "今日のお買い物　にんじん、ジャガイモ、豚肉")]),
                        ChatMessage(type: .mine, contents: [ChatMessageContent(text: "あとカレールーも")])]
        
        return ChatListView(messages: messages, scrollViewProxy: .constant(nil))
    }
}
