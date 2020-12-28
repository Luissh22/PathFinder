//
//  Queue.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-27.
//

import Foundation

class Queue: Collection {
    
    enum QueueType {
        case fifo, lifo
    }
    
    private var items: [GridItem]
    private let queueType: QueueType
    
    init(queueType: QueueType = .fifo) {
        self.queueType = queueType
        items = []
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    var size: Int {
        items.count
    }
    
    func insert(_ element: GridItem) {
        items.append(element)
    }
    
    func insert(_ elements: [GridItem]) {
        elements.forEach { insert($0) }
    }
    
    func pop() throws -> GridItem {
        
        guard !isEmpty else {
            throw CollectionError.emptyCollection
        }
        
        if queueType == .lifo {
            return items.removeLast()
        }
        
        return items.removeFirst()
    }
    
    func peek() throws -> GridItem {
        guard !isEmpty else {
            throw CollectionError.emptyCollection
        }
        
        if queueType == .lifo {
            return items.last!
        }
        
        return items.first!
    }
    
    func removeAll() {
        items.removeAll()
    }
    
    func contains(_ element: GridItem) -> Bool {
        items.contains(element)
    }
    
}
