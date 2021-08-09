//
//  CdistApiClient.swift
//  SecondMemory
//
//  Created by yum on 2021/07/19.
//

import Foundation

class CdistApiClient {
    private let idToken: String
    private let url: URL
    private let apiClient: ApiClient
    
    init(idToken: String) {
        self.idToken = idToken
        self.url = URL(string: "https://ss.yum14.icu/cdist/")!
        self.apiClient = ApiClient(idToken: idToken)
    }
    
    func get(search: String, completion: @escaping (CdistResponse) -> Void = { _ in }) {
        
        do {
            let queryItems = [URLQueryItem(name: "q", value: search)]
            
            try apiClient.get(url: self.url, queryItems: queryItems) {(status: Int?, response: CdistResponse?, error: Error?) in
                
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
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
