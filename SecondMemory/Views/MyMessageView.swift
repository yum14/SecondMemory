//
//  MyMessageView.swift
//  SecondMemory
//
//  Created by yum on 2021/06/22.
//

import SwiftUI

struct MyMessageView: View {
    var text: String
    
    var body: some View {
        HStack {
            Spacer()
            
            HStack {
                Text(self.text)
                    .foregroundColor(.white)
                    .lineLimit(nil)
            }
            .padding(12)
            .background(Color.secondary)
            .cornerRadius(14)
        }
    }
}

struct MyMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MyMessageView(text: "テキスト")
    }
}
