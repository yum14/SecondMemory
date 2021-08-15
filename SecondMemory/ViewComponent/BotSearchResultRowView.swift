//
//  BotSearchResultRowView.swift
//  SecondMemory
//
//  Created by yum on 2021/07/24.
//

import SwiftUI

struct BotSearchResultRowView: View {
    var text: String
    var onMovePressed: () -> Void = {}
    var onDeletePressed: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(self.text)
            
            HStack() {
            
                Spacer()
                
                Button("移動する") {
                    self.onMovePressed()
                }
                
                Button("忘れる") {
                    self.onDeletePressed()
                }
            }
        }
    }
}

struct BotSearchResultRowView_Previews: PreviewProvider {
    static var previews: some View {
        BotSearchResultRowView(text: "検索結果")
    }
}
