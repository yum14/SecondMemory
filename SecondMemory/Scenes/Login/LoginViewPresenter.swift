//
//  LoginPresenter.swift
//  SecondMemory
//
//  Created by yum on 2021/08/15.
//

import Foundation
import Combine

final class LoginViewPresenter: ObservableObject {
    
    @Published var showSheet = false
    
    func login() {
        self.showSheet = true
    }
    
}
