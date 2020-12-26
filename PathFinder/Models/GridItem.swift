//
//  GridItem.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-24.
//

import Foundation

struct GridItem: Equatable {
    
    static let defaultCost = -1
    
    var row: Int
    var col: Int
    var isWall = false
    var cost = defaultCost
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    static func ==(lhs: GridItem, rhs: GridItem) -> Bool {
        lhs.row == rhs.row && lhs.col == rhs.col
    }
    
}
