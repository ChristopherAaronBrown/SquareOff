//
//  SquareOffState.swift
//  Square Off
//
//  Created by Chris Brown on 9/15/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import GameplayKit

protocol SquareOffState {
    
    var session: GameSession { get }
    
    func boardSpaceTapped(at coordinate: BoardCoordinate)
    func tileTapped(tile: Tile)
}
