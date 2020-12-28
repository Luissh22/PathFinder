//
//  Dijkstra.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-26.
//

import Foundation

class Dijkstra: PathFinder {
    
    var queuedItems: Collection = PriorityQueue(sortCriteria: <)
    var checkedItems = Set<GridItem>()
    var path = [GridItem]()
    var cameFrom = [GridItem: GridItem]()
    var costSoFar = [GridItem: Int]()
    
    func findNextItems(given currentItem: GridItem, and itemsToCheck: [GridItem]) {
        for itemToCheck in itemsToCheck {
            guard !itemToCheck.isWall else { continue }
            let newCost = (costSoFar[currentItem] ?? 0) + itemToCheck.cost
            
            if shouldCheckItem(itemToCheck, fromCurrentItem: currentItem, potentialCost: newCost) {
                itemToCheck.cost = newCost
                costSoFar.updateValue(newCost, forKey: itemToCheck)
                queuedItems.insert(itemToCheck)
                checkedItems.insert(itemToCheck)
                cameFrom.updateValue(currentItem, forKey: itemToCheck)
            }
        }
    }
    
    func shouldCheckItem(_ item: GridItem, fromCurrentItem currentItem: GridItem, potentialCost: Int) -> Bool {
        costSoFar[item] == nil || potentialCost < costSoFar[item] ?? 0
    }
    
}
