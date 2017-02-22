//
//  PlayerBag.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

enum PlayerBagError: Error {
    case bagNotEmpty
}

class PlayerBag {
    var player: Player!
    var tiles: [Tile] = [Tile]()
    
    func populateInitialBag() {
        /*
         Starting bags have:
         - 5x SingleGemTile
         - 1x SingleStraightTile
         - 1x SingleDiagonalTile
         - 1x AttackTile
         - 1x DefendTile
         - 1x JumpTile
         */
        for _ in 0..<5 {
            tiles.append(GemTile(player: player, gem: Gem.Single))
        }
        tiles.append(SingleStraightTile(player: player))
        tiles.append(SingleDiagonalTile(player: player))
        tiles.append(AttackTile(player: player))
        tiles.append(DefendTile(player: player))
        tiles.append(JumpTile(player: player))
        
        tiles.append(KnightLeftTile(player: player))
        tiles.append(KnightRightTile(player: player))
        tiles.append(DoubleStraightTile(player: player))
        tiles.append(DoubleDiagonalTile(player: player))
        tiles.append(ZigZagLeftTile(player: player))
        tiles.append(ZigZagRightTile(player: player))
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
