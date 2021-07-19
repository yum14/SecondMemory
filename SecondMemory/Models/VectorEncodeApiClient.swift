//
//  VectorEncodeApiClient.swift
//  SecondMemory
//
//  Created by yum on 2021/07/14.
//

import Foundation

class VectorEncodeApiClient {
    private let idToken: String
    private let url = URL(string: "https://ss.yum14.icu/encode")!
    
    init(idToken: String) {
        self.idToken = idToken
    }
    
    
    func post(content: VectorEncodeRequest, completion: @escaping (Int?, VectorEncodeResponse?, Error?) -> Void) throws -> Void {
        
        var request = URLRequest(url: self.url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json",
                                       "Authorization": "Bearer \(self.idToken)"]
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(content)
            request.httpBody = jsonData
            
        } catch let error {
            completion(nil, nil, error)
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, nil, error)
                return
            }
            
            // httpステータスコード
            let status = (response as? HTTPURLResponse)?.statusCode
            guard let status = status else {
                completion(nil, nil, nil)
                return
            }
            
            guard let data = data else {
                return
            }
            
            // コンテンツのデシリアライズ
            let decoder = JSONDecoder()
            do {
                let obj = try decoder.decode(VectorEncodeResponse.self, from: data)
                completion(status, obj, nil)
            } catch let error {
                completion(status, nil, error)
                return
            }
        }
        task.resume()
    }
}

struct Hello: Codable {
    var message: String
}
