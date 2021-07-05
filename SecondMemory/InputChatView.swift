//
//  InputChatView.swift
//  SecondMemory
//
//  Created by yum on 2021/07/05.
//

import SwiftUI

struct InputChatView: View {
    @State private var height: CGFloat = 36
    @State private var resignFirstResponder: Bool = false
    
    @Binding var text: String
    var onCommit: (() -> Void)?
    
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            
            BotImageView(width: 44, height: 44)
//                .padding(.trailing, 8)
            
            MultiTextField(text: self.$text,
                           height: self.$height,
                           resignFirstResponder: self.$resignFirstResponder)
            
            VStack(spacing: 0) {
                Button(action: {
//                    if !self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                        self.messages.append(ChatMessage(id: "add" + String(messages.count), text: self.text, isMine: true))
//
//
//                        guard let proxy = self.scrollViewProxy,
//                              let message = self.messages.last else {
//                            return
//                        }
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                            withAnimation {
//                                //一番下にアニメーションする
//                                proxy.scrollTo(message.id, anchor: .bottom)
//                            }
//
//                        })
//
//                    }
                    
                    
                    self.onCommit?()
                    
                    self.text = ""
                    self.height = 36
                    self.resignFirstResponder = true
                }) {
                    Image(systemName: "paperplane.fill")
//                            .font(.title)
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                        .frame(height: 44)
                }
//                .padding(.leading, 4)
            }
        }
    }
}

struct InputChatView_Previews: PreviewProvider {
    static var previews: some View {
        InputChatView(text: .constant(""))
    }
}
