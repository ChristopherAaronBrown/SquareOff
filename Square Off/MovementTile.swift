//
//  MovementTile.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

protocol MovementTile {
    func getPaths(_ baseCoordinate: BoardCoordinate, player: Player) -> [Path]
}
