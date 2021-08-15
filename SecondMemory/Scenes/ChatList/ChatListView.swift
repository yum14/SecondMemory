//
//  ChatListView.swift
//  SecondMemory
//
//  Created by yum on 2021/07/02.
//

import SwiftUI

struct ChatListView: View {
    @ObservedObject var presenter: ChatListViewPresenter
    let uid: String
    let idToken: String
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView() {
                    LazyVStack {
                        
                        ForEach(self.presenter.messages.indices, id: \.self) { index in
                            let message = self.presenter.messages[index]
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
                                                        onDeletePressed: self.presenter.deleteVector)
                                        .layoutPriority(1)
                                        .padding(.trailing, 50)
                                        .padding(.leading, 4)
                                        .padding(.bottom, 12)
                                }
                            }
                            .id(message.id)
                            .onAppear {
                                self.presenter.loadId = message.id
                                self.presenter.listItemAppear(item: message)
                            }
                        }
                    }
                    .background(Color.red)
                }
                .onAppear {
                    self.presenter.scrollViewProxy = proxy
                    self.presenter.viewAppear(uid: self.uid, idToken: self.idToken)
                }
            }
            .onReceive(self.presenter.$messages, perform: { value in
                self.presenter.chatMessageReceive(newValue: value)
            })
            .onTapGesture {
                UIApplication.shared.closeKeyboard()
            }
            
            
            HStack(alignment: .bottom, spacing: 0) {
                Button(action: {
                    self.presenter.botIconTapped()
                }) {
                    BotImageView(width: 44, height: 44)
                        .padding(.trailing, 8)
                }

                InputChatView(text: self.$presenter.inputText,
                              searching: self.presenter.searching,
                              onCommit: {
                                self.presenter.textInputCommit()
                              },
                              onDismiss: {
                                self.presenter.textInputDismiss()
                              },
                              onBeginEditing: {
                                self.presenter.inputBeginEditing()
                              })
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)

        }
        .onAppear {
            // 時刻やバッテリー残量をタップしたときにリスト最上部までスクロールするのをオフにする
            UIScrollView.appearance().scrollsToTop = false
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let messages = [
            ChatMessage(type: .mine, contents: [ChatMessageContent(text: "自分のメッセージ")]),
            ChatMessage(type: .bot, contents: [ChatMessageContent(text: "ボットのメッセージ")]),
            ChatMessage(type: .search, contents: [ChatMessageContent(text: "検索結果1"),
                                                  ChatMessageContent(text: "検索結果2"),
                                                  ChatMessageContent(text: "検索結果3"),
                                                  ChatMessageContent(text: "検索結果4"),
                                                  ChatMessageContent(text: "検索結果5")])
        ]
        
        ChatListView(presenter: ChatListViewPresenter(messages: messages),
                     uid: "uid",
                     idToken: "idToken")
    }
}
