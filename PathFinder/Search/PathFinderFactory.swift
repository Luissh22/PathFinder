//
//  PathFinderFactory.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-27.
//

import Foundation

enum PathFinderFactoryError: Error {
    case unknownAlgorithm(_ algorithm: Algorithm)
}

class PathFinderFactory {
    
    func newPathFinder(for algorithm: Algorithm) throws -> PathFinder {
        switch algorithm {
        case .BreadthFirstSearch:
            return CostAgnosticSearch(searchType: .breadthFirstSearch)
        case .DepthFirstSearch:
            return CostAgnosticSearch(searchType: .depthFirstSearch)
        case .Dijkstras:
            return Dijkstra()
        default:
            throw PathFinderFactoryError.unknownAlgorithm(algorithm)
        }
    }
    
}
