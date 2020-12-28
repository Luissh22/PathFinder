//
//  PathFinder.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-26.
//

import Foundation

enum Algorithm {
    case BreadthFirstSearch
    case DepthFirstSearch
    case Dijkstras
    case AStar
    case GreedyBestFirstSearch
    
    var label: String {
        switch self {
        case .AStar:
            return "A* Search"
        case .BreadthFirstSearch:
            return "Breadth First Search"
        case .DepthFirstSearch:
            return "Depth First Search"
        case .Dijkstras:
            return "Dijkstra's Algorithm"
        case .GreedyBestFirstSearch:
            return "Greedy Best First Search"
        }
    }
}

protocol PathFinder {
    var queuedItems: Collection { get set }
    var checkedItems: Set<GridItem> { get set }
    var path: [GridItem] { get set }
    var cameFrom: [GridItem: GridItem] { get set }
    var costSoFar: [GridItem: Int] { get set }
    
    func findNextItems(given currentItem: GridItem, and itemsToCheck: [GridItem], goal: GridItem)
    
    func shouldCheckItem(_ item: GridItem, fromCurrentItem currentItem: GridItem, potentialCost: Int) -> Bool
    
    mutating func reset()
    
    mutating func selectRoute(start: GridItem, end: GridItem) -> Bool
}

extension PathFinder {
    
    mutating func reset() {
        queuedItems.removeAll()
        checkedItems.removeAll()
        path.removeAll()
        cameFrom.removeAll()
        costSoFar.removeAll()
    }
    
   mutating func selectRoute(start: GridItem, end: GridItem) -> Bool {
        guard checkedItems.contains(end) else {
            return false
        }
        
        var current = end
        
        while current != start {
            path.append(current)
            guard let cameFromCurrent = cameFrom[current] else {
                break
            }
            current = cameFromCurrent
        }
        
        return true
    }
    
    func shouldCheckItem(_ item: GridItem, fromCurrentItem currentItem: GridItem, potentialCost: Int) -> Bool {
        costSoFar[item] == nil || potentialCost < costSoFar[item] ?? 0
    }
}
