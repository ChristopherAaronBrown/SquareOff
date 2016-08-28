//
//  ZigZagLeftTile.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class ZigZagLeftTile: Tile, MovementTile {
    
    func getPaths(baseCoordinate: BoardCoordinate, player: Player) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertical-left-vertical
        if  let firstCoordinate = try? BoardCoordinate(column: baseCoordinate.column,
                                                       row: baseCoordinate.row + (1 * player.playerDirection)) {
            if let secondCoordinate = try? BoardCoordinate(column: baseCoordinate.column - (1 * player.playerDirection),
                                                           row: baseCoordinate.row + (1 * player.playerDirection)) {
                if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column - (1 * player.playerDirection),
                                                               row: baseCoordinate.row + (2 * player.playerDirection)) {
                    paths.append(Path(coordinates: [baseCoordinate, firstCoordinate, secondCoordinate, targetCoordinate]))
                }
            }
        }
        
        // Try to append Path right-vertical-right
        if  let firstCoordinate = try? BoardCoordinate(column: baseCoordinate.column + (1 * player.playerDirection),
                                                       row: baseCoordinate.row) {
            if let secondCoordinate = try? BoardCoordinate(column: baseCoordinate.column + (1 * player.playerDirection),
                                                           row: baseCoordinate.row + (1 * player.playerDirection)) {
                if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column + (2 * player.playerDirection),
                                                               row: baseCoordinate.row + (1 * player.playerDirection)) {
                    paths.append(Path(coordinates: [baseCoordinate, firstCoordinate, secondCoordinate, targetCoordinate]))
                }
            }
        }
        
        return paths
    }
    
    init() {
        super.init(cost: 5, imageName: "ZigZagLeftTile")
    }
}