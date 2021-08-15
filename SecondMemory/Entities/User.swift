//
//  User.swift
//  SecondMemory
//
//  Created by yum on 2021/08/09.
//

import Foundation
import Firebase

struct User: Identifiable, Codable {
    var id: String
    var displayName: String?
    var email: String?
    var photoUrl: String?
    var lastLogin: Timestamp? = Timestamp(date: Date())
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case email
        case photoUrl = "photo_url"
        case lastLogin = "last_login"
    }
}
