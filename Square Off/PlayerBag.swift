//
//  PlayerBag.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

enum PlayerBagError: ErrorType {
    case BagNotEmpty
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
        for _ in 0 ..< 5 {
            tiles.append(GemTile(value: 1))
        }
        tiles.append(Straight1Tile())
        tiles.append(Diagonal1Tile())
        tiles.append(AttackTile())
        tiles.append(DefendTile())
        tiles.append(JumpTile())
    }
    
    func refill(playerDiscard: PlayerDiscard) throws {
        guard tiles.count == 0 else { throw PlayerBagError.BagNotEmpty }
        guard playerDiscard.tiles.count > 0 else { throw PlayerDiscardError.NothingDiscarded }
        
        tiles.appendContentsOf(playerDiscard.tiles)
        playerDiscard.tiles.removeAll()
    }
    
    func draw() -> Tile? {
        guard tiles.count > 0 else { return nil }
        
        let randomIndex = Int(arc4random_uniform(UInt32(tiles.count)))
        
        return tiles.removeAtIndex(randomIndex)
    }
    
    func count() -> Int {
        return tiles.count
    }
}