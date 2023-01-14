//
//  Foundation+Extension.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/17.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
