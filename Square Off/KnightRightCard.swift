//
//  KnightRightCard.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class KnightRightCard: Card, MovementCard {
    
    func getPaths(_ source: Coordinate) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertical-vertical-right
        if  let second = try? Coordinate(column: source.column, row: source.row - 1) {
            if let third = try? Coordinate(column: source.column, row: source.row - 2) {
                if let target = try? Coordinate(column: source.column + 1, row: source.row - 2) {
                    paths.append(Path(coordinates: [source, second, third, target], movementCardType: type(of: self)))
                }
            }
        }
        
        // Try to append Path right-vertical-vertical
        if  let second = try? Coordinate(column: source.column + 1, row: source.row) {
            if let third = try? Coordinate(column: source.column + 1, row: source.row - 1) {
                if let target = try? Coordinate(column: source.column + 1, row: source.row - 2) {
                    paths.append(Path(coordinates: [source, second, third, target], movementCardType: type(of: self)))
                }
            }
        }
        
        // Try to append Path vertical-left-left
        if  let second = try? Coordinate(column: source.column, row: source.row - 1) {
            if let third = try? Coordinate(column: source.column - 1, row: source.row - 1) {
                if let target = try? Coordinate(column: source.column - 2, row: source.row - 1) {
                    paths.append(Path(coordinates: [source, second, third, target], movementCardType: type(of: self)))
                }
            }
        }
        
        // Try to append Path left-left-vertical
        if  let second = try? Coordinate(column: source.column - 1, row: source.row) {
            if let third = try? Coordinate(column: source.column - 2, row: source.row) {
                if let target = try? Coordinate(column: source.column - 2, row: source.row - 1) {
                    paths.append(Path(coordinates: [source, second, third, target], movementCardType: type(of: self)))
                }
            }
        }
        
        return paths
    }
    
    init() {
        super.init(cost: 5)
    }
}
