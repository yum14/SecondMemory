//
//  CdistApiClient.swift
//  SecondMemory
//
//  Created by yum on 2021/07/19.
//

import Foundation

class CdistApiClient {
    private let idToken: String
    private let url = URL(string: "https://ss.yum14.icu/cdist/")!
    
    init(idToken: String) {
        self.idToken = idToken
    }
    
    func get(search: String, completion: @escaping (Int?, CdistResponse?, Error?) -> Void) throws -> Void {
        
        var urlComponents = URLComponents(string: self.url.absoluteString)!
        urlComponents.queryItems = [URLQueryItem(name: "q", value: search)]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.idToken)"]
        
        
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
                let obj = try decoder.decode(CdistResponse.self, from: data)
                completion(status, obj, nil)
            } catch let error {
                completion(status, nil, error)
                return
            }
        }
        task.resume()
    }
    
}
