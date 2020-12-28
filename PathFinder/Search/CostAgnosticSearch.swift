//
//  CostAgnosticSearch.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-27.
//

import Foundation

class CostAgnosticSearch: PathFinder {
    enum SearchType {
        case breadthFirstSearch
        case depthFirstSearch
    }
    
    var searchType: SearchType
    var queuedItems: Collection
    var checkedItems = Set<GridItem>()
    var path = [GridItem]()
    var cameFrom = [GridItem: GridItem]()
    var costSoFar = [GridItem: Int]()
    
    init(searchType: SearchType) {
        self.searchType = searchType
        self.queuedItems = Queue(queueType: searchType == SearchType.breadthFirstSearch ? .fifo : .lifo)
    }
    
    func findNextItems(given currentItem: GridItem, and itemsToCheck: [GridItem]) {
        for itemToCheck in itemsToCheck {
            guard !itemToCheck.isWall else { continue }
        
            if shouldCheckItem(itemToCheck, fromCurrentItem: currentItem, potentialCost: 0) {
                itemToCheck.cost = currentItem.cost + 1
                queuedItems.insert(itemToCheck)
                checkedItems.insert(itemToCheck)
                cameFrom.updateValue(currentItem, forKey: itemToCheck)
            }
        }
    }
    
    func shouldCheckItem(_ item: GridItem, fromCurrentItem currentItem: GridItem, potentialCost: Int) -> Bool {
        cameFrom[item] == nil
    }
    
}

