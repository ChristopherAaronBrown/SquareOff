//
//  Straight1Tile.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class Straight1Tile: Tile, MovementTile {
    
    func getPaths(baseCoordinate: BoardCoordinate, player: Player) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertically
        if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column,
                                                       row: baseCoordinate.row + (1 * player.playerDirection)) {
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
    
    init() {
        super.init(cost: 3, imageName: "Straight1Tile")
    }
}