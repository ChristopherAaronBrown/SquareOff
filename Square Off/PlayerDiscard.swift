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
    
    init() {
        self.tiles = [Tile]()
    }
    
    func add(_ tile: Tile) {
        self.tiles.append(tile)
    }
    
    func count() -> Int {
        return self.tiles.count
    }
}
