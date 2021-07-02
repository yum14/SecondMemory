//
//  BotChatView.swift
//  SecondMemory
//
//  Created by yum on 2021/06/21.
//

import SwiftUI

struct BotChatView: View {
    var text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            BotImageView(width: 44, height: 44)

            VStack {
                Text(self.text)
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

struct BotChatView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BotChatView(text: "コメント")
                .background(Color.secondary)
        }
    }
}
