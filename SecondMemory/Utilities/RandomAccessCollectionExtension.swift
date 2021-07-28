//
//  RandomAccessCollectionExtension.swift
//  SecondMemory
//
//  Created by yum on 2021/07/27.
//

import Foundation

extension RandomAccessCollection where Self.Element: Identifiable {
    public func isFirstItem<Item: Identifiable>(_ item: Item) -> Bool {
        guard !isEmpty else {
            return false
        }
        
        guard let itemIndex = lastIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else {
            return false
        }

        print("********* startIndex: \(startIndex)")
        print("********* index: \(itemIndex)")

        let distance = self.distance(from: startIndex, to: itemIndex)
        return distance == 1
    }
    
    public func isLastItem<Item: Identifiable>(_ item: Item) -> Bool {
        guard !isEmpty else {
            return false
        }

        guard let itemIndex = lastIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else {
            return false
        }

        let distance = self.distance(from: itemIndex, to: endIndex)
        return distance == 1
    }
}
