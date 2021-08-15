//
//  InputChatView.swift
//  SecondMemory
//
//  Created by yum on 2021/07/05.
//

import SwiftUI

struct InputChatView: View {
    @State private var height: CGFloat = 36
    @Binding var text: String
    var searching = false
    var onCommit: () -> Void = {}
    var onDismiss: () -> Void = {}
    var onBeginEditing: () -> Void = {}
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            
            MultiTextField(text: self.$text,
                           height: self.$height,
                           isFirstResponder: self.searching,
                           onBeginEditing: self.onBeginEditing)
            
            VStack(spacing: 0) {
                Button(action: {
                    
                    self.onCommit()

                    self.text = ""
                    self.height = 36
                    
                    UIApplication.shared.closeKeyboard()
                    
                    self.onDismiss()
                    
                }) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                        .frame(height: 44)
                }
            }
        }
    }
}

struct InputChatView_Previews: PreviewProvider {
    static var previews: some View {
        InputChatView(text: .constant(""))
    }
}
