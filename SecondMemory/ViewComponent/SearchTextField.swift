//
//  SearchTextField.swift
//  SecondMemory
//
//  Created by yum on 2021/08/15.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var text: String
    @State private var isFirstResponder = true
    var onCommit: () -> Void = {}
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            CustomTextField("検索する", text: self.$text, isFirstResponder: self.isFirstResponder, onCommit: self.onCommit)
                .frame(height: 22)
                .autocapitalization(.none)
//                .padding()
//            TextField("検索する", text: self.$text)
        }
        .padding()
        .background(Color.secondary)
        .cornerRadius(14)
    }
}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField(text: .constant(""))
    }
}
