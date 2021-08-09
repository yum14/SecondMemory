//
//  ChatListView.swift
//  SecondMemory
//
//  Created by yum on 2021/07/02.
//

import SwiftUI

struct ChatListView: View {
    
    @State var text = ""
    @ObservedObject var presenter: ChatListViewPresenter
//    var idToken: String
//    var messages: [ChatMessage]
//    var addChatMessage: (ChatMessage) -> Void = { _ in }
//    var deleteVector: (String) -> Void = { _ in }
  
//    var fetchData: () -> Void = {}
    
//    @State var text: String = ""
//    @State private var firstAppear = true
//    @State private var height: CGFloat = 36
//    @Binding var scrollViewProxy: ScrollViewProxy?
    
//    @State var searching = false
    
    var body: some View {
        VStack {
            
            ChatScrollView(messages: self.presenter.messages,
                           scrollViewProxy: self.$presenter.scrollViewProxy,
                         deleteVector: self.presenter.deleteVector,
                         onListItemAppear: self.presenter.listItemAppear)
                .onReceive(self.presenter.$messages, perform: { value in
                    self.presenter.chatMessageReceive(newValue: value)
                })
            
            HStack(alignment: .bottom, spacing: 0) {
                Button(action: {
                    self.presenter.botIconTapped()
                }) {
                    BotImageView(width: 44, height: 44)
                        .padding(.trailing, 8)
                }

                InputChatView(text: self.$text,
                              searching: self.presenter.searching,
                              onCommit: {
                                self.presenter.textInputCommit()
                              },
                              onDismiss: {
                                self.presenter.textInputDismiss()
                              })
                    .onChange(of: self.text, perform: { value in
                        // presenter.inputTextを指定してもバインドされないためここで直接値を入れる
                        self.presenter.inputText = value
                    })
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)

        }
    }
}

//struct ChatListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatListView(idToken: "", messages: [ChatMessage(id: "id", type: .mine, contents: [ChatMessageContent(id: "id", text: "test1")])], scrollViewProxy: .constant(nil))
//    }
//}
