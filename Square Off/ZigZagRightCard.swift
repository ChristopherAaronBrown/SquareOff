//
//  ZigZagRightCard.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class ZigZagRightCard: Card, MovementCard {
    
    func getPaths(_ baseCoordinate: Coordinate, player: Player) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertical-right-vertical
        if  let firstCoordinate = try? Coordinate(column: baseCoordinate.column,
                                                       row: baseCoordinate.row - (1 * player.direction)) {
            if let secondCoordinate = try? Coordinate(column: baseCoordinate.column + (1 * player.direction),
                                                           row: baseCoordinate.row - (1 * player.direction)) {
                if let targetCoordinate = try? Coordinate(column: baseCoordinate.column + (1 * player.direction),
                                                               row: baseCoordinate.row - (2 * player.direction)) {
                    paths.append(Path(coordinates: [baseCoordinate, firstCoordinate, secondCoordinate, targetCoordinate], movementCardType: type(of: self)))
                }
            }
        }
        
        // Try to append Path left-vertical-left
        if  let firstCoordinate = try? Coordinate(column: baseCoordinate.column - (1 * player.direction),
                                                       row: baseCoordinate.row) {
            if let secondCoordinate = try? Coordinate(column: baseCoordinate.column - (1 * player.direction),
                                                           row: baseCoordinate.row - (1 * player.direction)) {
                if let targetCoordinate = try? Coordinate(column: baseCoordinate.column - (2 * player.direction),
                                                               row: baseCoordinate.row - (1 * player.direction)) {
                    paths.append(Path(coordinates: [baseCoordinate, firstCoordinate, secondCoordinate, targetCoordinate], movementCardType: type(of: self)))
                }
            }
        }
        
        return paths
    }
    
    init() {
        super.init(cost: 5)
    }
}
