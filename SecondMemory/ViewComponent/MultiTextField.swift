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
    
    // いまいちだけど制御難しいからクリアしたときのheight(36)は外から指定させる
    @Binding var height: CGFloat
    var isFirstResponder = false
    var onBeginEditing: () -> Void = {}
    
    var body: some View {
        UITextViewWrapper(height: self.$height,
                          placeholder: "メッセージを入力",
                          text: self.$text,
                          isFirstResponder: self.isFirstResponder,
                          onBeginEditing: self.onBeginEditing)
            .padding(4)
            .background(Color.secondary)
            .cornerRadius(16)
    }
}

struct MultiTextField_Previews: PreviewProvider {
    static var previews: some View {
        MultiTextField(text: .constant(""), height: .constant(36))
    }
}

struct UITextViewWrapper: View {
    @Binding var height: CGFloat
    var placeholder: String?
    @Binding var text: String
    var isFirstResponder = false
    var onBeginEditing: () -> Void = {}
    
    var body: some View {
        RepresentableUITextView(height: $height,
                                placeholder: self.placeholder,
                                text: self.$text,
                                isFirstResponder: self.isFirstResponder,
                                onBeginEditing: self.onBeginEditing)
            .frame(height: self.height < 150 ? self.height : 150)
    }
}

struct RepresentableUITextView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return RepresentableUITextView.Coordinator(parent: self)
    }
    
    @Binding var height: CGFloat
    var placeholder: String? = "テキストを入力"
    @Binding var text: String
    var isFirstResponder = false
    var onBeginEditing: () -> Void = {}
    
    func makeUIView(context: UIViewRepresentableContext<RepresentableUITextView>) -> UITextView {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        
        if self.text.isEmpty {
            view.text = placeholder
            view.textColor = UIColor.black.withAlphaComponent(0.35)
        } else {
            view.text = self.text
            view.textColor = .black
        }

        view.backgroundColor = .clear
        view.delegate = context.coordinator
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        
        
        return view
    }
    
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if self.isFirstResponder {
            uiView.becomeFirstResponder()
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RepresentableUITextView
        
        init(parent: RepresentableUITextView) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            // Viewを選択して入力開始する時にplaceholderを消している（色も変えてる）
            textView.text = ""
            textView.textColor = .black
            
            self.parent.onBeginEditing()
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
            self.parent.height = textView.contentSize.height
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if parent.text.isEmpty {
                textView.text = self.parent.placeholder
                textView.textColor = UIColor.black.withAlphaComponent(0.35)
                textView.backgroundColor = .clear
            }
        }
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
