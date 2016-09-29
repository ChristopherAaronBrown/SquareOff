//
//  Diagonal1Tile.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class Diagonal1Tile: Tile, MovementTile {
    
    func getPaths(_ baseCoordinate: BoardCoordinate, player: Player) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertical-left
        if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column - 1,
                                                       row: baseCoordinate.row - (1 * player.direction)) {
            paths.append(Path(coordinates: [baseCoordinate, targetCoordinate]))
        }
        
        // Try to append Path vertical-right
        if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column + 1,
                                                       row: baseCoordinate.row - (1 * player.direction)) {
            paths.append(Path(coordinates: [baseCoordinate, targetCoordinate]))
        }
        
        return paths
    }
    
    init() {
        super.init(cost: 3, imageName: "Diagonal1Tile")
    }
}
