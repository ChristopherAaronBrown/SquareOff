//
//  ZigZagRightTile.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class ZigZagRightTile: Tile, MovementTile {
    
    func getPaths(_ baseCoordinate: BoardCoordinate, player: Player) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertical-right-vertical
        if  let firstCoordinate = try? BoardCoordinate(column: baseCoordinate.column,
                                                       row: baseCoordinate.row - (1 * player.direction)) {
            if let secondCoordinate = try? BoardCoordinate(column: baseCoordinate.column + (1 * player.direction),
                                                           row: baseCoordinate.row - (1 * player.direction)) {
                if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column + (1 * player.direction),
                                                               row: baseCoordinate.row - (2 * player.direction)) {
                    paths.append(Path(coordinates: [baseCoordinate, firstCoordinate, secondCoordinate, targetCoordinate]))
                }
            }
        }
        
        // Try to append Path left-vertical-left
        if  let firstCoordinate = try? BoardCoordinate(column: baseCoordinate.column - (1 * player.direction),
                                                       row: baseCoordinate.row) {
            if let secondCoordinate = try? BoardCoordinate(column: baseCoordinate.column - (1 * player.direction),
                                                           row: baseCoordinate.row - (1 * player.direction)) {
                if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column - (2 * player.direction),
                                                               row: baseCoordinate.row - (1 * player.direction)) {
                    paths.append(Path(coordinates: [baseCoordinate, firstCoordinate, secondCoordinate, targetCoordinate]))
                }
            }
        }
        
        return paths
    }
    
    init() {
        super.init(cost: 5, imageName: "ZigZagRightTile")
    }
}
