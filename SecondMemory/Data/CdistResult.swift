//
//  CdistResult.swift
//  SecondMemory
//
//  Created by yum on 2021/07/19.
//

import Foundation

struct CdistResult: Identifiable, Encodable, Decodable {
    var id: String
    var sentence: String
    var score: Float
}
