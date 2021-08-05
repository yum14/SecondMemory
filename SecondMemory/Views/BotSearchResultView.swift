//
//  BotSearchResultView.swift
//  SecondMemory
//
//  Created by yum on 2021/07/24.
//

import SwiftUI

struct BotSearchResultView: View {
    
    var messages: [ChatMessageContent]
    var onMovePressed: (String) -> Void = {_ in}
    var onDeletePressed: (String) -> Void = {_ in}
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            BotImageView(width: 44, height: 44)
            
            VStack {
                VStack {
                    ForEach(self.messages.indices, id: \.self) { index in
                        BotSearchResultRowView(text: self.messages[index].text,
                                               onMovePressed: { self.onMovePressed(self.messages[index].id) },
                                               onDeletePressed: { self.onDeletePressed(self.messages[index].id) })
                            .id(index)
                    }
                }
                .foregroundColor(.white)
                .lineLimit(nil)
                .padding(12)
                .background(Color.secondary)
                .cornerRadius(14)
            }
            .padding(.leading, 4)
            
            Spacer()
        }
    }
}

struct BotSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        BotSearchResultView(messages: [ChatMessageContent(text: "文章1"),
                                       ChatMessageContent(text: "文章2"),
                                       ChatMessageContent(text: "文章3")])
    }
}
