//
//  GridItem.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-24.
//

import Foundation

class GridItem {
    var id = UUID()
    static let defaultCost = 1
    
    var row: Int
    var col: Int
    var isWall = false
//    var cost = Int.random(in: 1...5)
    var priority = 0
    var cost = defaultCost
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
}

extension GridItem: Equatable {
    static func ==(lhs: GridItem, rhs: GridItem) -> Bool {
        lhs.row == rhs.row && lhs.col == rhs.col
    }
}

extension GridItem: Comparable {
    static func < (lhs: GridItem, rhs: GridItem) -> Bool {
        lhs.cost < rhs.cost
    }
}

extension GridItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
        hasher.combine(isWall)
        hasher.combine(cost)
        hasher.combine(id)
        hasher.combine(priority)
    }
}
