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
    @Published var loadId = ""
    @Published var searching = false
    @Published var scrollViewProxy: ScrollViewProxy? = nil
    
    private var uid: String? = nil
    private var idToken: String? = nil
    private let messageStore: MessageStore?
    private let vectorStore: VectorStore?
    private var isFirstRead = true
    private var isFirstResponder = true
    private var scrollToButtom = false
    
    init() {
        self.vectorStore = VectorStore.shared
        self.messageStore = MessageStore.shared
    }
    
    init(messages: [ChatMessage]) {
        self.messages = messages
        self.vectorStore = nil
        self.messageStore = nil
    }
    
    func botIconTapped() {
        let text = "検索ワードをチャットしてけろ。"
        
        guard let uid = self.uid else {
            return
        }
        // firestoreにデータ追加
        let doc = ChatMessage(type: .bot, contents: [ChatMessageContent(text: text)])
        self.messageStore?.add(uid: uid, doc)
        self.searching = true
        self.inputText = "> "
    }
    
    func listItemAppear(item: ChatMessage) -> Void {
        if self.messages.isFirstItem(item) && !self.isFirstResponder && !self.isFirstRead {
            // 新しいページデータを取得
            self.messageStore?.fetch()
        }
    }
    
    func textInputCommit() {
        guard let uid = self.uid else {
            return
        }
        
        if self.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        
        let contentId = UUID().uuidString
        // firestoreにデータ追加
        let doc = ChatMessage(type: .mine, contents: [ChatMessageContent(id: contentId, text: self.inputText)])
        self.messageStore?.add(uid: uid, doc)
        
        
        if self.inputText.hasPrefix("> ") {
            let search = String(self.inputText.suffix(self.inputText.count - 2))
            
            // top5まで似た文章を取得
            let cdistApiClient = CdistApiClient(idToken: self.idToken!)
            cdistApiClient.get(search: search, completion: { [weak self] response in
                let doc = ChatMessage(type: .search, contents: response.result.map { ChatMessageContent(id: $0.id, text: $0.sentence, score: $0.score) })
                
                if let self = self {
                    self.messageStore?.add(uid: uid, doc)
                }
            })
            
        } else {
            // ベクトル化して保存
            let vectorEncodeApiClient = VectorEncodeApiClient(idToken: idToken!)
            vectorEncodeApiClient.post(id: contentId, sentence: self.inputText)
        }
        
        if self.searching {
            self.searching.toggle()
        }
        
        scrollToButtom = true
    }
    
    func textInputDismiss() {
        if self.searching {
            self.searching.toggle()
        }
    }
    
    func inputBeginEditing() {
        let selectedIndex = self.messages.firstIndex(where: { $0.id == self.loadId })!
        let lastIndex = self.messages.firstIndex(where: {$0.id == self.messages.last!.id})!
        
        // リストの最下部が表示されているとき（おおよそ・・）、キーボード表示に合わせて最下部が隠れてしまわないようにスクロールする
        if selectedIndex + 12 >= lastIndex {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {[weak self] in
                if let self = self {
                    self.scrollViewProxy?.scrollTo(self.messages.last!.id, anchor: .top)
                }
            })
        }
    }

    func deleteVector(id: String) -> Void {
        guard let uid = self.uid else {
            return
        }
        self.vectorStore?.delete(uid: uid, id: id)
    }
    
    func chatMessageReceive(newValue: [ChatMessage]) {
        if newValue.count > 0 {
            if self.isFirstRead || scrollToButtom {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {[weak self] in
                    withAnimation {
                        // 一番下にスクロールする
                        self?.scrollViewProxy?.scrollTo(newValue.count - 1, anchor: .bottom)
                        
                        self?.isFirstRead = false
                        self?.scrollToButtom = false
                    }
                })

            }
        }
    }
    
    func viewAppear(uid: String, idToken: String) {
        if self.isFirstResponder {
            self.uid = uid
            self.idToken = idToken
            
            messageStore?.setListener(uid: uid, onListen: {[weak self] newMessages in
                if let self = self {
                    self.messages = newMessages
                    print("firstCount: \(self.messages.count)")
                }
            })
            
            self.isFirstResponder.toggle()
        }

    }
        
}
