//
//  BindingExtension.swift
//  SecondMemory
//
//  Created by yum on 2021/07/21.
//

import Foundation
//
//extension Binding {
//    /// Wrapper to listen to didSet of Binding
//    func didSet(_ didSet: @escaping ((newValue: Value, oldValue: Value)) -> Void) -> Binding<Value> {
//        return .init(get: { self.wrappedValue }, set: { newValue in
//            let oldValue = self.wrappedValue
//            self.wrappedValue = newValue
//            didSet((newValue, oldValue))
//        })
//    }
//    
//    /// Wrapper to listen to willSet of Binding
//    func willSet(_ willSet: @escaping ((newValue: Value, oldValue: Value)) -> Void) -> Binding<Value> {
//        return .init(get: { self.wrappedValue }, set: { newValue in
//            willSet((newValue, self.wrappedValue))
//            self.wrappedValue = newValue
//        })
//    }
//}
