//
//  BotImageView.swift
//  SecondMemory
//
//  Created by yum on 2021/06/20.
//

import SwiftUI

struct BotImageView: View {
    var width: CGFloat
    var height: CGFloat
    var backgroundColor: Color?
    
    var body: some View {
        Image("Bot")
            .resizable()
            .frame(width: self.width, height: self.height, alignment: .center)
            .background(self.backgroundColor ?? Color.white)
            .clipShape(Circle())
    }
}

struct BotImageView_Previews: PreviewProvider {
    static var previews: some View {
        BotImageView(width: 120, height: 120, backgroundColor: Color(UIColor(hex: "ff00ff")))
    }
}
