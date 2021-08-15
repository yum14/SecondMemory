//
//  VectorEncodeResponse.swift
//  SecondMemory
//
//  Created by yum on 2021/07/17.
//

import Foundation

struct VectorEncodeResponse: Identifiable, Encodable, Decodable {
    var id: String
    var errors: [ResponseError]
}
