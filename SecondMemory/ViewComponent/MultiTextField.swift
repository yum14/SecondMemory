//
//  MultiTextField.swift
//  SecondMemory
//
//  Created by yum on 2021/07/04.
//

import Foundation
import SwiftUI

struct MultiTextField: View {
    @Binding var text: String
    @State var height: CGFloat = 36
    @State var isFirstResponder: Bool = false
    var becomeFirstResponder = false
    var onBeginEditing: () -> Void = {}
    var inisitalText: String = ""
    @State var showPlaceholder = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            if self.showPlaceholder {
                Text("メッセージを入力")
                    .padding(.leading, 8)
                    .foregroundColor(.secondary)
            }
            
            RepresentableUITextView(height: $height,
                                    text: self.$text,
                                    isFirstResponder: self.$isFirstResponder,
                                    becomeFirstResponder: self.becomeFirstResponder,
                                    onBeginEditing: self.onBeginEditing,
                                    initialText: self.inisitalText)
                .frame(height: self.height < 150 ? self.height : 150)
                .padding(4)
                .background(Color.secondary)
                .cornerRadius(16)
                .onChange(of: self.text, perform: { value in
                    if self.text.isEmpty {
                        self.height = 36
                        
                        if self.isFirstResponder {
                            self.showPlaceholder = true
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                                self.showPlaceholder = true
                            })
                        }
                    } else {
                        self.showPlaceholder = false
                    }
                })
        }
    }
}

struct MultiTextField_Previews: PreviewProvider {
    static var previews: some View {
        MultiTextField(text: .constant(""))
    }
}

struct RepresentableUITextView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return RepresentableUITextView.Coordinator(parent: self)
    }
    
    @Binding var height: CGFloat
    @Binding var text: String
    @Binding var isFirstResponder: Bool
    var becomeFirstResponder = false
    var onBeginEditing: () -> Void = {}
    var initialText: String = ""
    
    func makeUIView(context: UIViewRepresentableContext<RepresentableUITextView>) -> UITextView {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        
        view.text = self.text
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        self.isFirstResponder = view.isFirstResponder
        
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {        
        if uiView.markedTextRange == nil {
            // 日本語確定前の状態ではセットしない
            uiView.text = self.text
        }
        
        if self.becomeFirstResponder {
            uiView.becomeFirstResponder()
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RepresentableUITextView
        
        init(parent: RepresentableUITextView) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            self.parent.onBeginEditing()
            self.parent.isFirstResponder = true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
            self.parent.height = textView.contentSize.height
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            self.parent.isFirstResponder = false
        }
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
