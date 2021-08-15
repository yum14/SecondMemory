//
//  VectorEncodeApiClient.swift
//  SecondMemory
//
//  Created by yum on 2021/07/14.
//

import Foundation

class VectorEncodeApiClient {
    private let idToken: String
    private let url: URL
    private let apiClient: ApiClient
    
    init(idToken: String) {
        self.idToken = idToken
        self.url = URL(string: "https://ss.yum14.icu/encode")!
        self.apiClient = ApiClient(idToken: idToken)
    }
    
    
    func post(id: String, sentence: String, completion: @escaping (VectorEncodeResponse) -> Void = { _ in }) {

        do {
            let content = VectorEncodeRequest(id: id, sentence: sentence)
            try apiClient.post(url: self.url, content: content) {(status: Int?, response: VectorEncodeResponse?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let status = status else {
                    print("no http statuscode.")
                    return
                }
                
                print("HTTP status: \(String(status))")
                
                if let response = response {
                    completion(response)
                }
            }
        } catch let error{
            print(error.localizedDescription)
        }
        
    }
}

