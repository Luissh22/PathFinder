//
//  AStarSearch.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-27.
//

import Foundation

class AStarSearch: PathFinder {
    
    var queuedItems: Collection = PriorityQueue() {
        $0.priority < $1.priority
    }
    var checkedItems = Set<GridItem>()
    var path = [GridItem]()
    var cameFrom = [GridItem: GridItem]()
    var costSoFar = [GridItem: Int]()
    
    func findNextItems(given currentItem: GridItem, and itemsToCheck: [GridItem], goal: GridItem) {
        for itemToCheck in itemsToCheck {
            guard !itemToCheck.isWall else { continue }
            
            let newCost = (costSoFar[currentItem] ?? 0) + itemToCheck.cost
            
            if shouldCheckItem(itemToCheck, fromCurrentItem: currentItem, potentialCost: newCost) {
                itemToCheck.cost = newCost
                itemToCheck.priority = newCost + ManhattanDistance.distance(a: itemToCheck, b: goal)
                costSoFar.updateValue(newCost, forKey: itemToCheck)
                queuedItems.insert(itemToCheck)
                checkedItems.insert(itemToCheck)
                cameFrom.updateValue(currentItem, forKey: itemToCheck)
            }
        }
    }
    
}
