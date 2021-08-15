//
//  ApiClient.swift
//  SecondMemory
//
//  Created by yum on 2021/08/08.
//

import Foundation

class ApiClient {
    let idToken: String
    
    init(idToken: String) {
        self.idToken = idToken
    }
    
    func get<T: Decodable>(url: URL, queryItems: [URLQueryItem], completion: @escaping (Int?, T?, Error?) -> Void) throws -> Void {
        
        var urlComponents = URLComponents(string: url.absoluteString)!
        urlComponents.queryItems = queryItems
        
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
                let obj = try decoder.decode(T.self, from: data)
                completion(status, obj, nil)
            } catch let error {
                completion(status, nil, error)
                return
            }
        }
        task.resume()
    }
    
    func post<T1: Codable, T2: Decodable>(url: URL, content: T1, completion: @escaping (Int?, T2?, Error?) -> Void) throws -> Void {
        
        var request = URLRequest(url: url)
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
                let obj = try decoder.decode(T2.self, from: data)
                completion(status, obj, nil)
            } catch let error {
                completion(status, nil, error)
                return
            }
        }
        task.resume()
    }
}
