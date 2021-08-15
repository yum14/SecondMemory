//
//  CdistResponse.swift
//  SecondMemory
//
//  Created by yum on 2021/07/19.
//

import Foundation

struct CdistResponse: Encodable, Decodable {
    var result: [CdistResult]
    var errors: [ResponseError]
}
