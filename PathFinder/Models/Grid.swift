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
    
    var noRouteFound: Bool = false
    
    let factory = PathFinderFactory()
    var gridItems: [[GridItem]]
    var start: GridItem
    let end: GridItem
    let rowSize: Int
    let colSize: Int
    let traverseDiagonals: Bool
    
    var timer: Cancellable?
    
    var pathFinder: PathFinder
    
    init(rowSize: Int = defaultSize,
         colSize: Int = defaultSize,
         traverseDiagonals: Bool = true,
         algorithm: Algorithm) {
        self.rowSize = rowSize
        self.colSize = colSize
        self.traverseDiagonals = traverseDiagonals
        self.gridItems = Grid.makeGrid(rowSize: rowSize, colSize: colSize)
        self.start = gridItems[1][1]
        self.end = gridItems[rowSize - 2][colSize - 2]
        self.pathFinder = try! factory.newPathFinder(for: algorithm)
    }
    
    func setPathFinder(for algorithm: Algorithm) {
        self.pathFinder = try! factory.newPathFinder(for: algorithm)
    }
    
    private static func makeGrid(rowSize: Int, colSize: Int) -> [[GridItem]] {
        var grid = [[GridItem]]()
        
        for row in 0..<rowSize {
            var cols = [GridItem]()
            for col in 0..<colSize {
                let gridItem = GridItem(row: row, col: col)
                cols.append(gridItem)
            }
            grid.append(cols)
        }
        
        return grid
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
        
        if pathFinder.path.contains(gridItem) {
            return .yellow
        }
        
        if pathFinder.queuedItems.contains(gridItem) {
            return .purple
        }
        
        if pathFinder.checkedItems.contains(gridItem) {
            return Color(.sRGB, red: 99/255, green: 172/255, blue: 229/255, opacity: 1)
        }
        
        return Color.white
    }
}

// MARK: - Grid specific methods
extension Grid {
    
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
        
        if traverseDiagonals {
            
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
        }
        
        return neighbours
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
        
        for _ in 1...400 {
            let randomRow = Int.random(in: 0..<rowSize)
            let randomCol = Int.random(in: 0..<colSize)
            gridItems[randomRow][randomCol].isWall = false
        }
        route()
    }
    
    
    func clear() {
        timer?.cancel()
        objectWillChange.send()
        pathFinder.reset()
        
        for row in gridItems {
            for col in row {
                col.cost = Int.random(in: 1...5)
//                col.cost = GridItem.defaultCost
            }
        }
    }
    
}

// MARK: - Routing methods
extension Grid {
    
    func route() {
        clear()
        
        pathFinder.queuedItems.insert(start)
        pathFinder.cameFrom[start] = start
        start.cost = 0
        pathFinder.costSoFar[start] = start.cost
        
        timer = DispatchQueue.main.schedule(after: .init(.now()), interval: 0.01, stepRoute)
    
    }
    
    private func stepRoute() {
        objectWillChange.send()
        
        do {
            let item = try pathFinder.queuedItems.pop()
            
            
            if item == end {
                selectRoute()
                return
            }
            
            let itemsToCheck = neighbours(for: item)
        
            pathFinder.findNextItems(given: item, and: itemsToCheck, goal: end)
            
            if pathFinder.queuedItems.isEmpty {
                // we're done searching for items
                selectRoute()
            }
        } catch {
            print(error)
        }
    }
    
    private func selectRoute() {
        timer?.cancel()
        objectWillChange.send()
        guard pathFinder.selectRoute(start: start, end: end) else {
            print("No Route Found")
            noRouteFound = true
            return
        }
    }
}
