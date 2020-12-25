//
//  GridItem.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-24.
//

import Foundation

struct GridItem: Equatable {
    var row: Int
    var col: Int
    var isWall = false
    var cost = -1
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    static func ==(lhs: GridItem, rhs: GridItem) -> Bool {
        lhs.row == rhs.row && lhs.col == rhs.col
    }
    
}
