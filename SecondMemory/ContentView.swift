//
//  ContentView.swift
//  SecondMemory
//
//  Created by yum on 2021/06/20.
//

import SwiftUI
import Firebase

struct ContentView: View {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some View {
        ChatBotView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
