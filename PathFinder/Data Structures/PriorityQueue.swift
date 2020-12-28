//
//  Heap.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-25.
//

import Foundation

class PriorityQueue: Collection {
    
    private var items: [GridItem]
    private let sortCriteria: (GridItem, GridItem) -> Bool
    
    init(sortCriteria: @escaping (GridItem, GridItem) -> Bool) {
        self.sortCriteria = sortCriteria
        items = []
    }
    
    var size: Int {
        items.count
    }
    
    private func leftChildIndex(of index: Int) -> Int {
        (index * 2) + 1
    }
    
    private func rightChildIndex(of index: Int) -> Int {
        (index * 2) + 2
    }
    
    private func parentIndex(of index: Int) -> Int {
        (index - 1) / 2
    }
    
    private func hasLeftChild(_ index: Int) -> Bool {
        leftChildIndex(of: index) < size
    }
    
    private func hasRightChild(_ index: Int) -> Bool {
        rightChildIndex(of: index) < size
    }
    
    private func isRoot(_ index: Int) -> Bool {
        index == 0
    }
    
    private func hasParent(_ index: Int) -> Bool {
        guard index > 0 else { return false }
        return parentIndex(of: index) >= 0
    }
    
    private func leftChild(of index: Int) -> GridItem? {
        guard hasLeftChild(index) else { return nil }
        
        return items[leftChildIndex(of: index)]
    }
    
    private func rightChild(of index: Int) -> GridItem? {
        guard hasRightChild(index) else { return nil }
        
        return items[rightChildIndex(of: index)]
    }
    
    private func parent(of index: Int) -> GridItem? {
        guard hasParent(index) else { return nil }
        
        return items[parentIndex(of: index)]
    }
    
    private func swap(_ indexOne: Int, _ indexTwo: Int) {
        guard indexOne != indexTwo else { return }
        items.swapAt(indexOne, indexTwo)
    }
    
    private func hasHigherPriority(indexOne: Int, indexTwo: Int) -> Bool {
        sortCriteria(items[indexOne], items[indexTwo])
    }
    
    // Compares parent and child index to see which has the higher priority
    private func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < size, hasHigherPriority(indexOne: childIndex, indexTwo: parentIndex) else {
            return parentIndex
        }
        
        return childIndex
    }
    
    // Returns the index with the highest priority, could be parent, left or right child
    private func highestPriorityIndex(for parentIndex: Int) -> Int {
        let highestPriorityIndexParentAndLeftChild = highestPriorityIndex(of: parentIndex, and: leftChildIndex(of: parentIndex))
        return highestPriorityIndex(of: highestPriorityIndexParentAndLeftChild, and: rightChildIndex(of: parentIndex))
    }
    
    private func shiftDown(from index: Int) {
        // Find out which is the highest priority index
        // Parent, left child or right child
        let highestPriority = highestPriorityIndex(for: index)
        if index == highestPriority { return } // no need to swap
        
        // Swap current index with higher priority index as this should be on top
        swap(index, highestPriority)
        
        shiftDown(from: highestPriority)
    }
    
    private func shiftUp(from index: Int) {
        // Compare current node (index) with parent
        // If current node is root, we're at the top
        // If current node has higher priority than parent, we swap
        // If we swap, call this method recursively with updated index (parent index)
        let parentIdx = parentIndex(of: index)
        guard !isRoot(index) else { return }
        // Child must have higher priority than parent if we want to swap
        guard hasHigherPriority(indexOne: index, indexTwo: parentIdx) else { return }
        
        swap(index, parentIdx)
        
        shiftUp(from: parentIdx)
    }
}

// Public methods
extension PriorityQueue {
    
    func insert(_ item: GridItem) {
        items.append(item)
        shiftUp(from: size - 1)
    }
    
    func insert(_ items: [GridItem]) {
        items.forEach { insert($0) }
    }
    
    func peek() throws -> GridItem {
        guard let item = items.first else {
            throw CollectionError.emptyCollection
        }
        
        return item
    }
    
    func pop() throws -> GridItem {
        guard !isEmpty else { throw CollectionError.emptyCollection }
        
        // Replace first item with last item in heap
        swap(0, size - 1)
        let item = items.removeLast()
        
        if !isEmpty {
            // Shift item down to correct spot
            shiftDown(from: 0)
        }
        
        return item
    }

    func contains(_ item: GridItem) -> Bool {
        items.contains(item)
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    func removeAll() {
        items.removeAll()
    }
    
}

