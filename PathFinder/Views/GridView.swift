//
//  GridView.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-24.
//

import SwiftUI
import Combine

struct GridView: View {
    
    enum DrawingMode {
        case none, drawing, removing
    }
    
    @StateObject var grid = Grid()
    @State private var drawingMode = DrawingMode.none
    let gridItemSize: CGFloat = 40
    
    var body: some View {
        VStack {
            ToolBarView(buttons: toolbarButtons)
            VStack(spacing: 0) {
                ForEach(0..<grid.rowSize) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<grid.colSize) { col in
                            let gridItem = grid.gridItems[row][col]
                            
                            ZStack {
                                Rectangle()
                                    .fill(grid.color(for: gridItem))
                                    .border(Color.black)
                                if !gridItem.isWall {
                                    Text("\(gridItem.cost)")
                                }
                            }
                            .frame(width: gridItemSize, height: gridItemSize)
                        }
                    }
                }
            }
            .gesture(dragGesture)
        }
    }
    
    private var toolbarButtons: [ButtonConfig] {
        [
            ButtonConfig(label: "Find Route", action: {}),
            ButtonConfig(label: "Clear Route", action: {}),
            ButtonConfig(label: "Clear Walls") {
                withAnimation {
                    grid.clearWalls()
                }
            }
        ]
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 1)
            .onChanged { value in
                let row = Int(value.location.y / gridItemSize)
                let col = Int(value.location.x / gridItemSize)
                
                guard row >= 0 && row < grid.rowSize else { return }
                guard col >= 0 && col < grid.colSize else { return }
                
                let gridItem = grid.gridItems[row][col]
                
                // Not currently drawing
                if drawingMode == .none {
                    drawingMode = gridItem.isWall ? .removing : .drawing
                }
                
                if drawingMode == .drawing {
                    grid.addWall(to: gridItem)
                } else {
                    grid.removeWall(for: gridItem)
                }
            }
            .onEnded { _ in
                drawingMode = .none
            }
    }
}
