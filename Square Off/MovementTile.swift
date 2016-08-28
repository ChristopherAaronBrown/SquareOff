//
//  MovementTile.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

protocol MovementTile {
    
    func getPaths(baseCoordinate: BoardCoordinate, player: Player) -> [Path]

}