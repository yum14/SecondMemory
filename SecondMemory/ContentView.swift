//
//  ContentView.swift
//  SecondMemory
//
//  Created by yum on 2021/06/20.
//

import SwiftUI

struct ContentView: View {
    
    // TODO: 仮データ
    let messages = [ChatMessage(id: "a", text: "テキスト1", isMine: false),
                    ChatMessage(id: "a", text: "テキスト2", isMine: false),
                    ChatMessage(id: "b", text: "テキスト3", isMine: true),
                    ChatMessage(id: "c", text: "テキスト4", isMine: true),]
    
    var body: some View {
        ChatListView(messages: self.messages)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
