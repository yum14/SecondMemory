//
//  SearchTextField.swift
//  SecondMemory
//
//  Created by yum on 2021/08/15.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("プレースホルダー", text: self.$text)
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
