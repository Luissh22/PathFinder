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
    
    @State private var menuLabel = "Algorithms"
    @StateObject private var grid = Grid(algorithm: Algorithm.BreadthFirstSearch)
    
    @State private var drawingMode = DrawingMode.none
    let gridItemSize: CGFloat = 40
    
    var body: some View {
        VStack {
            HStack {
                Menu(menuLabel) {
                    ToolBarView(buttons: menuButtons)
                }
                ToolBarView(buttons: toolbarButtons)
            }
            VStack(spacing: 0) {
                ForEach(0..<grid.rowSize) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<grid.colSize) { col in
                            let gridItem = grid.gridItems[row][col]
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(grid.color(for: gridItem))
                                    .border(Color.black)
                                if !gridItem.isWall {
                                    Text("\(gridItem.cost)")
                                        .foregroundColor(textColor(for: gridItem))
                                }
                            }
                            .frame(width: gridItemSize, height: gridItemSize)
                        }
                    }
                }
            }
            .gesture(dragGesture)
        }
        .alert(isPresented: $grid.noRouteFound) {
            Alert(title: Text("No Route Found"), message: Text("Please try again"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func textColor(for item: GridItem) -> Color {
        let gridColor = grid.color(for: item)
        if gridColor == .white || gridColor == .yellow {
            return .black
        }
        
        return .white
    }
    
    private var toolbarButtons: [ButtonConfig] {
        [
            ButtonConfig(label: "Find Route", action: grid.route),
            ButtonConfig(label: "Clear Route", action: grid.clear),
            ButtonConfig(label: "Clear Walls") {
                withAnimation {
                    grid.clearWalls()
                }
            },
            ButtonConfig(label: "Randomize Walls", action: grid.randomizeWalls)
        ]
    }
    
    private var menuButtons: [ButtonConfig] {
        
        [
            ButtonConfig(label: Algorithm.AStar.label, action: {
                grid.clear()
                grid.setPathFinder(for: .AStar)
                menuLabel = Algorithm.AStar.label
            }),
            ButtonConfig(label: Algorithm.GreedyBestFirstSearch.label, action: {
                grid.clear()
                grid.setPathFinder(for: .GreedyBestFirstSearch)
                menuLabel = Algorithm.GreedyBestFirstSearch.label
            }),
            ButtonConfig(label: Algorithm.Dijkstras.label, action: {
                grid.clear()
                grid.setPathFinder(for: .Dijkstras)
                menuLabel = Algorithm.Dijkstras.label
            }),
            ButtonConfig(label: Algorithm.BreadthFirstSearch.label, action: {
                grid.clear()
                grid.setPathFinder(for: .BreadthFirstSearch)
                menuLabel = Algorithm.BreadthFirstSearch.label
            }),
            ButtonConfig(label: Algorithm.DepthFirstSearch.label, action: {
                grid.clear()
                grid.setPathFinder(for: .DepthFirstSearch)
                menuLabel = Algorithm.DepthFirstSearch.label
            })
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
