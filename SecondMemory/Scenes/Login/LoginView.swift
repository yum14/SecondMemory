//
//  LoginView.swift
//  SecondMemory
//
//  Created by yum on 2021/08/15.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var presenter: LoginViewPresenter
    
    var body: some View {
        VStack {
            Text("ログインしよう")
                .padding()
            Button("ログイン") {
                self.presenter.login()
            }
        }
        .sheet(isPresented: self.$presenter.showSheet, content: {
            FirebaseUIView()
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(presenter: LoginViewPresenter())
    }
}
