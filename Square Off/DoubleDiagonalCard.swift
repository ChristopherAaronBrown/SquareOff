//
//  DoubleDiagonalCard.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class DoubleDiagonalCard: Card, MovementCard {
    
    func getPaths(_ baseCoordinate: Coordinate, player: Player) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertical-left
        if  let midCoordinate = try? Coordinate(column: baseCoordinate.column - 1,
                                                     row: baseCoordinate.row - (1 * player.direction)) {
            if let targetCoordinate = try? Coordinate(column: baseCoordinate.column - 2,
                                                           row: baseCoordinate.row - (2 * player.direction)) {
                paths.append(Path(coordinates: [baseCoordinate, midCoordinate, targetCoordinate], movementCardType: type(of: self)))
            }
        }
        
        // Try to append Path vertical-right
        if  let midCoordinate = try? Coordinate(column: baseCoordinate.column + 1,
                                                     row: baseCoordinate.row - (1 * player.direction)) {
            if let targetCoordinate = try? Coordinate(column: baseCoordinate.column + 2,
                                                           row: baseCoordinate.row - (2 * player.direction)) {
                paths.append(Path(coordinates: [baseCoordinate, midCoordinate, targetCoordinate], movementCardType: type(of: self)))
            }
        }
        
        return paths
    }
    
    init() {
        super.init(cost: 5)
    }
}
