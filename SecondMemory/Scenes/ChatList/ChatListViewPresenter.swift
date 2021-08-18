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
    @Published var showSearchText = false
    @Published var searchText = ""
    
    private var uid: String? = nil
    private var idToken: String? = nil
    private let messageStore: MessageStore?
    private let vectorStore: VectorStore?
    private var isFirstRead = true
    private var isFirstResponder = true
    private var scrollToButtom = false
    
    init() {
        self.vectorStore = VectorStore()
        self.messageStore = MessageStore()
    }
    
    init(messages: [ChatMessage]) {
        self.messages = messages
        self.vectorStore = nil
        self.messageStore = nil
    }
    
    func botIconTapped() {
        self.showSearchText = true
    }
    
    func searchTextFieldCommit() {
        
        if !searchText.isEmpty, let uid = self.uid {
            // top5まで似た文章を取得
            let cdistApiClient = CdistApiClient(idToken: self.idToken!)
            cdistApiClient.get(search: self.searchText, completion: { [weak self] response in
                let doc = ChatMessage(type: .search, contents: response.result.sorted(by: { $1.score < $0.score }).map { ChatMessageContent(id: $0.id, text: $0.sentence, score: $0.score) })
                
                print("********* 検索結果 *********")
                doc.contents.forEach {
                    print("id:\($0.id), sentence:\($0.text), score:\(String($0.score ?? 0))")
                }
                
                if let self = self {
                    self.messageStore?.add(uid: uid, doc)
                }
            })
        }
        
        self.searchText = ""
        self.showSearchText = false
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
        let doc = ChatMessage(id: contentId, type: .mine, contents: [ChatMessageContent(id: contentId, text: self.inputText)])
        self.messageStore?.add(uid: uid, doc)
        
        
//        if self.inputText.hasPrefix("> ") {
//            let search = String(self.inputText.suffix(self.inputText.count - 2))
//
//            // top5まで似た文章を取得
//            let cdistApiClient = CdistApiClient(idToken: self.idToken!)
//            cdistApiClient.get(search: search, completion: { [weak self] response in
//                let doc = ChatMessage(type: .search, contents: response.result.map { ChatMessageContent(id: $0.id, text: $0.sentence, score: $0.score) })
//
//                if let self = self {
//                    self.messageStore?.add(uid: uid, doc)
//                }
//            })
//
//        } else {
            // ベクトル化して保存
            let vectorEncodeApiClient = VectorEncodeApiClient(idToken: idToken!)
            vectorEncodeApiClient.post(id: contentId, sentence: self.inputText)
//        }
        
        if self.searching {
            self.searching.toggle()
        }

        self.scrollToButtom = true
    }
    
    func textInputDismiss() {
        if self.searching {
            self.searching.toggle()
        }
    }
    
    func inputBeginEditing() {
        let selectedIndex = self.messages.firstIndex(where: { $0.id == self.loadId })
        let lastIndex = self.messages.firstIndex(where: {$0.id == self.messages.last?.id ?? ""})
        
        if let selected = selectedIndex, let last = lastIndex {
            // リストの最下部が表示されているとき（おおよそ・・）、キーボード表示に合わせて最下部が隠れてしまわないようにスクロールする
            if selected + 12 >= last {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {[weak self] in
                    if let self = self, let lastItem = self.messages.last {
                        self.scrollViewProxy?.scrollTo(lastItem.id, anchor: .bottom)
                    }
                })
            }
        }
    }
    
    func moveMessage(id: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {[weak self] in
            self?.scrollViewProxy?.scrollTo(id, anchor: .top)
        })
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
