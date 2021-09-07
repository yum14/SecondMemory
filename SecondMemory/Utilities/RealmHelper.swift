//
//  RealmHelper.swift
//  SecondMemory
//
//  Created by yum on 2021/08/22.
//

import Foundation
import RealmSwift


class RealmHelper {
    static let defaultUrl = Realm.Configuration.defaultConfiguration.fileURL
    
    static func createRealm() -> Realm {
        var config = Realm.Configuration()
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.icu.yum14.SecondMemory")!
        config.fileURL = url.appendingPathComponent("default.realm")
        return try! Realm(configuration: config)
    }
}
