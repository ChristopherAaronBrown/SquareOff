//
//  PlayerBag.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

enum PlayerBagError: Error {
    case bagNotEmpty
}

class PlayerBag {
    var tiles: [Tile] = [Tile]()
    
    init() {
        /**
         Starting bags have:
         - 5x GemTile (1)
         - 1x Straight1Tile
         - 1x Diagonal1Tile
         - 1x AttackTile
         - 1x DefendTile
         - 1x JumpTile
        */
        for _ in 0..<5 {
            tiles.append(GemTile(value: 1))
        }
        tiles.append(Straight1Tile())
        tiles.append(Diagonal1Tile())
        tiles.append(AttackTile())
        tiles.append(DefendTile())
        tiles.append(JumpTile())
    }
    
    func refill(_ playerDiscard: PlayerDiscard) throws {
        guard tiles.count == 0 else { throw PlayerBagError.bagNotEmpty }
        guard playerDiscard.tiles.count > 0 else { throw PlayerDiscardError.nothingDiscarded }
        
        tiles.append(contentsOf: playerDiscard.tiles)
        playerDiscard.tiles.removeAll()
    }
    
    func draw() -> Tile? {
        guard tiles.count > 0 else { return nil }
        
        let randomIndex = Int(arc4random_uniform(UInt32(tiles.count)))
        
        return tiles.remove(at: randomIndex)
    }
    
    func count() -> Int {
        return tiles.count
    }
}
