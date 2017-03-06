//
//  PlayerDeck.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

enum PlayerBagError: Error {
    case bagNotEmpty
}

class PlayerDeck {
    var player: Player!
    var tiles: [Card] = [Card]()
    
    var count: Int {
        return tiles.count
    }
    
    func populateInitialBag() {
        /*
         Starting bags have:
         - 5x SingleGemCard
         - 1x SingleStraightCard
         - 1x SingleDiagonalCard
         - 1x AttackCard
         - 1x DefendCard
         - 1x JumpCard
         */
        for _ in 0..<5 {
            tiles.append(GemCard(player: player, gem: Gem.Single))
        }
        tiles.append(SingleStraightCard(player: player))
        tiles.append(SingleDiagonalCard(player: player))
        tiles.append(AttackCard(player: player))
        tiles.append(DefendCard(player: player))
        tiles.append(DoubleStraightCard(player: player))
        
        // TODO: Remove when done testing
        tiles.append(JumpCard(player: player))
        tiles.append(KnightLeftCard(player: player))
        tiles.append(KnightRightCard(player: player))
        tiles.append(DoubleDiagonalCard(player: player))
        tiles.append(ZigZagLeftCard(player: player))
        tiles.append(ZigZagRightCard(player: player))
        
        tiles.append(ResurrectCard(player: player))
        tiles.append(ResurrectCard(player: player))
        tiles.append(ResurrectCard(player: player))
        tiles.append(ResurrectCard(player: player))
    }
    
    func refill(_ playerDiscard: PlayerDiscard) throws {
        guard tiles.count == 0 else { throw PlayerBagError.bagNotEmpty }
        guard playerDiscard.tiles.count > 0 else { throw PlayerDiscardError.nothingDiscarded }
        
        tiles.append(contentsOf: playerDiscard.tiles)
        playerDiscard.tiles.removeAll()
    }
    
    func draw() -> Card? {
        guard tiles.count > 0 else { return nil }
        
        let randomIndex = Int(arc4random_uniform(UInt32(tiles.count)))
        
        return tiles.remove(at: randomIndex)
    }
}
