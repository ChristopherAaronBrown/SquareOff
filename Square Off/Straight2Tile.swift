//
//  Straight2Tile.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class Straight2Tile: Tile, MovementTile {
    
    func getPaths(baseCoordinate: BoardCoordinate, player: Player) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertically
        if  let midCoordinate = try? BoardCoordinate(column: baseCoordinate.column,
                                                     row: baseCoordinate.row + (1 * player.playerDirection)) {
            if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column,
                                                           row: baseCoordinate.row + (2 * player.playerDirection)) {
                paths.append(Path(coordinates: [baseCoordinate, midCoordinate, targetCoordinate]))
            }
        }
        
        // Try to append Path to left
        if  let midCoordinate = try? BoardCoordinate(column: baseCoordinate.column - 1, row: baseCoordinate.row) {
            if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column - 2, row: baseCoordinate.row) {
                paths.append(Path(coordinates: [baseCoordinate, midCoordinate, targetCoordinate]))
            }
        }
        
        // Try to append Path to right
        if  let midCoordinate = try? BoardCoordinate(column: baseCoordinate.column + 1, row: baseCoordinate.row) {
            if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column + 2, row: baseCoordinate.row) {
                paths.append(Path(coordinates: [baseCoordinate, midCoordinate, targetCoordinate]))
            }
        }
        
        return paths
    }
    
    init() {
        super.init(cost: 4, imageName: "Straight2Tile")
    }
}