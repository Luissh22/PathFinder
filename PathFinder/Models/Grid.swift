//
//  Grid.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-24.
//

import Combine
import SwiftUI

class Grid: ObservableObject {
    static let defaultSize = 20
    
    var gridItems: [[GridItem]]
    var start: GridItem
    let end: GridItem
    let rowSize: Int
    let colSize: Int
    
    var queuedItems: Heap<GridItem> = Heap(sortCriteria: <)
    var checkedItems = [GridItem]()
    var path = [GridItem]()
    
    var timer: Cancellable?
    
    init(rowSize: Int = defaultSize,
         colSize: Int = defaultSize) {
        var grid = [[GridItem]]()
        
        for row in 0..<rowSize {
            var cols = [GridItem]()
            for col in 0..<colSize {
                let gridItem = GridItem(row: row, col: col)
                cols.append(gridItem)
            }
            grid.append(cols)
        }
        
        self.rowSize = rowSize
        self.colSize = colSize
        gridItems = grid
        start = grid[1][1]
        end = grid[rowSize - 2][colSize - 2]
    }
    
    func randomizeWalls() {
        clear()

        for row in gridItems {
            for col in row {
                if col == start { continue }
                if col == end { continue }
                col.isWall = true
            }
        }

        for _ in 1...250 {
            let randomRow = Int.random(in: 0..<rowSize)
            let randomCol = Int.random(in: 0..<colSize)
            gridItems[randomRow][randomCol].isWall = false
        }
        route()
    }
    
    func color(for gridItem: GridItem) -> Color {
        if gridItem == start {
            return Color.green
        }
        
        if gridItem == end {
            return Color.red
        }
        
        if gridItem.isWall {
            return Color.black
        }
        
        if path.contains(gridItem) {
            return .white
        }
        
        if queuedItems.contains(gridItem) {
            return .orange
        }

        if checkedItems.contains(gridItem) {
            return Color.orange.opacity(0.5)
        }

        return Color.gray
    }
    
    func clear() {
        timer?.cancel()
        objectWillChange.send()
        queuedItems.removeAll()
        checkedItems.removeAll()
        path.removeAll()
        
        for row in gridItems {
            for col in row {
                col.cost = GridItem.defaultCost
            }
        }
    }
    
    func route() {
        clear()
        
        queuedItems.insert(start)
        start.cost = 0
        
        timer = DispatchQueue.main.schedule(after: .init(.now()), interval: 0.01, stepRoute)
        
    }
    
    func stepRoute() {
        objectWillChange.send()
        
        do {
            let item = try queuedItems.pop()
            checkedItems.append(item)

            if item == end {
                selectRoute()
                return
            }

            findNextItems(from: item)

            if queuedItems.isEmpty {
                // we're done searching for items
                selectRoute()
            }
        } catch {
            print(error)
        }
    }
    
    func findNextItems(from item: GridItem) {
        let itemsToCheck = neighbours(for: item)
        
        for itemToCheck in itemsToCheck {
            guard !itemToCheck.isWall else { continue }
        
            if shouldCheckItem(itemToCheck, fromCurrentItem: item) {
                itemToCheck.cost = item.cost + 1
                queuedItems.insert(itemToCheck)
            }
        }
    }
    
    func shouldCheckItem(_ item: GridItem, fromCurrentItem currentItem: GridItem) -> Bool {
        item.cost == -1 || currentItem.cost + 1 < currentItem.cost
    }
    
    func addWall(to gridItem: GridItem) {
        guard gridItem != start && gridItem != end else { return }
        addWall(to: gridItem.row, col: gridItem.col)
    }
    
    private func addWall(to row: Int, col: Int) {
        guard !gridItems[row][col].isWall else { return }

        objectWillChange.send()
        gridItems[row][col].isWall = true
    }
    
    func removeWall(for gridItem: GridItem) {
        removeWall(at: gridItem.row, col: gridItem.col)
    }
    
    private func removeWall(at row: Int, col: Int) {
        guard gridItems[row][col].isWall else { return }
        objectWillChange.send()
        
        gridItems[row][col].isWall = false
    }
    
    func clearWalls() {
        objectWillChange.send()
        for row in gridItems {
            for item in row {
                removeWall(for: item)
            }
        }
    }
    
    func neighbours(for gridItem: GridItem) -> [GridItem] {
        var neighbours = [GridItem]()
        
        let row = gridItem.row
        let col = gridItem.col
        
        // Row above
        if row > 0 {
            neighbours.append(gridItems[row - 1][col])
        }
        
        // Row below
        if row < rowSize - 1 {
            neighbours.append(gridItems[row + 1][col])
        }
        
        // Column to the left
        if col > 0 {
            neighbours.append(gridItems[row][col - 1])
        }
        
        // Column to the right
        if col < colSize - 1 {
            neighbours.append(gridItems[row][col + 1])
        }
        
        if row > 0 {
            // Upper left diagonal
            if col > 0 {
                neighbours.append(gridItems[row - 1][col - 1])
            }
            
            // Upper right diagonal
            if col < colSize - 1 {
                neighbours.append(gridItems[row - 1][col + 1])
            }
        }
        
        if row < rowSize - 1 {
            // Lower left diagonal
            if col > 0 {
                neighbours.append(gridItems[row + 1][col - 1])
            }
            
            // Lower right diagonal
            if col < colSize - 1 {
                neighbours.append(gridItems[row + 1][col + 1])
            }
        }
        
        return neighbours
    }
    
    func selectRoute() {
        timer?.cancel()
        objectWillChange.send()
        guard end.cost != GridItem.defaultCost else {
            print("No route found")
            return
        }
        
        path.append(end)
        
        var current = end
        
        while current != start {
            for neighbour in neighbours(for: current) {
                // Make sure we have scanned this neighbour
                guard neighbour.cost != GridItem.defaultCost else { continue }
                
                if current.cost > neighbour.cost {
                    // Part of the path
                    path.append(neighbour)
                    current = neighbour
                    break
                }
            }
        }
        
    }
}
