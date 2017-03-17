//
//  SingleStraightCard.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class SingleStraightCard: Card, MovementCard {
    
    func getPaths(_ baseCoordinate: Coordinate, player: Player) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertically
        if let targetCoordinate = try? Coordinate(column: baseCoordinate.column,
                                                       row: baseCoordinate.row - (1 * player.direction)) {
            paths.append(Path(coordinates: [baseCoordinate, targetCoordinate], movementCardType: type(of: self)))
        }
        
        // Try to append Path to left
        if let targetCoordinate = try? Coordinate(column: baseCoordinate.column - 1, row: baseCoordinate.row) {
            paths.append(Path(coordinates: [baseCoordinate, targetCoordinate], movementCardType: type(of: self)))
        }
        
        // Try to append Path to right
        if let targetCoordinate = try? Coordinate(column: baseCoordinate.column + 1, row: baseCoordinate.row) {
            paths.append(Path(coordinates: [baseCoordinate, targetCoordinate], movementCardType: type(of: self)))
        }
        
        return paths
    }
    
    init() {
        super.init(cost: 3)
    }
}
