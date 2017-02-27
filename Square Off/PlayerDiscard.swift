//
//  PlayerDiscard.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

enum PlayerDiscardError: Error {
    case nothingDiscarded
}

class PlayerDiscard {
    var tiles: [Tile]
    
    var count: Int {
        return tiles.count
    }
    
    init() {
        tiles = [Tile]()
    }
    
    func add(_ tile: Tile) {
        tiles.append(tile)
    }
}
