//
//  Grid.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-24.
//

import SwiftUI

class Grid: ObservableObject {
    static let defaultSize = 20
    
    var gridItems: [[GridItem]]
    let start: GridItem
    let end: GridItem
    let rowSize: Int
    let colSize: Int
    
    init(rowSize: Int = defaultSize, colSize: Int = defaultSize) {
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
        
        return Color.gray
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
}
