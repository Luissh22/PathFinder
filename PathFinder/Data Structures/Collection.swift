//
//  Queue.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-27.
//

import Foundation

protocol Collection {
    
    var isEmpty: Bool { get }
    var size: Int { get }
    
    func insert(_ element: GridItem)
    func insert(_ elements: [GridItem])
    func pop() throws -> GridItem
    func peek() throws -> GridItem
    func removeAll()
    func contains(_ element: GridItem) -> Bool
}

enum CollectionError: Error {
    case emptyCollection
}
