//
//  ChatListPresenter.swift
//  SecondMemory
//
//  Created by yum on 2021/08/07.
//

import Foundation
import SwiftUI
import Combine

final class ChatListViewPresenter: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var searching = false
    @Published var scrollViewProxy: ScrollViewProxy? = nil
    
    private let idToken: String
    private let messageStore: MessageStore
    private let vectorStore: VectorStore
    private var isFirstResponder = true
    private var cdistApiClient: CdistApiClient
    private var vectorEncodeApiClient: VectorEncodeApiClient
    
//    init(idToken: String, messageStore: MessageStore, vectorStore: VectorStore) {
//        self.idToken = idToken
//        self.messageStore = messageStore
//        self.vectorStore = vectorStore
//        self.cdistApiClient = CdistApiClient(idToken: idToken)
//        self.vectorEncodeApiClient = VectorEncodeApiClient(idToken: idToken)
//    }
  
    init(uid: String, idToken: String) {
        self.idToken = idToken
        self.vectorStore = VectorStore(uid: uid)
        self.cdistApiClient = CdistApiClient(idToken: idToken)
        self.vectorEncodeApiClient = VectorEncodeApiClient(idToken: idToken)
        self.messageStore = MessageStore(uid: uid)
        messageStore.didSet = {[weak self] newMessages in
            self?.messages = newMessages
        }
    }
    
    func botIconTapped() {
        let text = "検索ワードをチャットしてけろ。"
        
        // firestoreにデータ追加
        let doc = ChatMessage(type: .bot, contents: [ChatMessageContent(text: text)])
        self.messageStore.add(doc)
        self.searching = true
        self.inputText = "> "
    }
    
    func listItemAppear(item: ChatMessage) -> Void {
        if self.messages.isFirstItem(item) {
            // 新しいページデータを取得
            self.messageStore.fetch()
        }
    }
    
    func textInputCommit() {
        if self.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        
        let contentId = UUID().uuidString
        // firestoreにデータ追加
        let doc = ChatMessage(type: .mine, contents: [ChatMessageContent(id: contentId, text: self.inputText)])
        self.messageStore.add(doc)
        
        
        if self.inputText.hasPrefix("> ") {
            let search = String(self.inputText.suffix(self.inputText.count - 2))
            
            // top5まで似た文章を取得
            cdistApiClient.get(search: search, completion: { [weak self] response in
                let doc = ChatMessage(type: .search, contents: response.result.map { ChatMessageContent(id: $0.id, text: $0.sentence, score: $0.score) })
                
                self?.messageStore.add(doc)
            })
            
        } else {
            // ベクトル化して保存
            vectorEncodeApiClient.post(id: contentId, sentence: self.inputText)
        }
        
        if self.searching {
            self.searching.toggle()
        }
    }
    
    func textInputDismiss() {
        if self.searching {
            self.searching.toggle()
        }
    }

    func deleteVector(id: String) -> Void {
        self.vectorStore.delete(id: id)
    }
    
    func chatMessageReceive(newValue: [ChatMessage]) {
        if newValue.count > 0 {
            if self.isFirstResponder {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    withAnimation {
                        // 一番下にスクロールする
                        self.scrollViewProxy?.scrollTo(newValue.count - 1, anchor: .bottom)
                        
                    }
                })
                
                self.isFirstResponder = false
            }
        }
    }
        
}
