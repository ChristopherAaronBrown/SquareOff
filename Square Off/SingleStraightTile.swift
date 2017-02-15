//
//  SingleStraightTile.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class SingleStraightTile: Tile, MovementTile {
    
    func getPaths(_ baseCoordinate: BoardCoordinate, player: Player) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertically
        if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column,
                                                       row: baseCoordinate.row - (1 * player.direction)) {
            paths.append(Path(coordinates: [baseCoordinate, targetCoordinate]))
        }
        
        // Try to append Path to left
        if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column - 1, row: baseCoordinate.row) {
            paths.append(Path(coordinates: [baseCoordinate, targetCoordinate]))
        }
        
        // Try to append Path to right
        if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column + 1, row: baseCoordinate.row) {
            paths.append(Path(coordinates: [baseCoordinate, targetCoordinate]))
        }
        
        return paths
    }
    
    init(player: Player) {
        let image = player.number == 0 ? #imageLiteral(resourceName: "SingleStraightPink") : #imageLiteral(resourceName: "SingleStraightGreen")
        super.init(player: player, cost: 3, image: image)
    }
}
