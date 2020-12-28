//
//  ManhattanDistance.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-27.
//

import Foundation

struct ManhattanDistance {
    static func distance(a: GridItem, b: GridItem) -> Int {
        abs(a.row - b.row) + abs(a.col - b.col)
    }
}
