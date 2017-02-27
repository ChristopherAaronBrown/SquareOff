//
//  KnightLeftTile.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class KnightLeftTile: Tile, MovementTile {
    
    func getPaths(_ baseCoordinate: BoardCoordinate, player: Player) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertical-vertical-left
        if  let firstCoordinate = try? BoardCoordinate(column: baseCoordinate.column,
                                                       row: baseCoordinate.row - (1 * player.direction)) {
            if let secondCoordinate = try? BoardCoordinate(column: baseCoordinate.column,
                                                           row: baseCoordinate.row - (2 * player.direction)) {
                if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column - (1 * player.direction),
                                                               row: baseCoordinate.row - (2 * player.direction)) {
                    paths.append(Path(coordinates: [baseCoordinate, firstCoordinate, secondCoordinate, targetCoordinate], movementTileType: type(of: self)))
                }
            }
        }
        
        // Try to append Path left-vertical-vertical
        if  let firstCoordinate = try? BoardCoordinate(column: baseCoordinate.column - (1 * player.direction),
                                                       row: baseCoordinate.row) {
            if let secondCoordinate = try? BoardCoordinate(column: baseCoordinate.column - (1 * player.direction),
                                                           row: baseCoordinate.row - (1 * player.direction)) {
                if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column - (1 * player.direction),
                                                               row: baseCoordinate.row - (2 * player.direction)) {
                    paths.append(Path(coordinates: [baseCoordinate, firstCoordinate, secondCoordinate, targetCoordinate], movementTileType: type(of: self)))
                }
            }
        }
        
        // Try to append Path vertical-right-right
        if  let firstCoordinate = try? BoardCoordinate(column: baseCoordinate.column,
                                                       row: baseCoordinate.row - (1 * player.direction)) {
            if let secondCoordinate = try? BoardCoordinate(column: baseCoordinate.column + (1 * player.direction),
                                                           row: baseCoordinate.row - (1 * player.direction)) {
                if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column + (2 * player.direction),
                                                               row: baseCoordinate.row - (1 * player.direction)) {
                    paths.append(Path(coordinates: [baseCoordinate, firstCoordinate, secondCoordinate, targetCoordinate], movementTileType: type(of: self)))
                }
            }
        }
        
        // Try to append Path right-right-vertical
        if  let firstCoordinate = try? BoardCoordinate(column: baseCoordinate.column + (1 * player.direction),
                                                       row: baseCoordinate.row) {
            if let secondCoordinate = try? BoardCoordinate(column: baseCoordinate.column + (2 * player.direction),
                                                           row: baseCoordinate.row) {
                if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column + (2 * player.direction),
                                                               row: baseCoordinate.row - (1 * player.direction)) {
                    paths.append(Path(coordinates: [baseCoordinate, firstCoordinate, secondCoordinate, targetCoordinate], movementTileType: type(of: self)))
                }
            }
        }
        
        return paths
    }
    
    init(player: Player) {
        let image = player.number == 0 ? #imageLiteral(resourceName: "KnightLeftPink") : #imageLiteral(resourceName: "KnightLeftGreen")
        super.init(player: player, cost: 5, image: image)
    }
}
