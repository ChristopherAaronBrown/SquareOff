//
//  Deck.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

enum DeckError: Error {
    case deckNotEmpty
}

class Deck {
    var player: Player!
    private var deck: [Card] = [Card]()
    
    var count: Int {
        return deck.count
    }
    
    func populateInitialDeck() {
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
            deck.append(GemCard(gem: Gem.Single))
        }
        deck.append(SingleStraightCard())
        deck.append(SingleDiagonalCard())
        deck.append(AttackCard())
        deck.append(DefendCard())
        deck.append(DoubleStraightCard())
        
        // TODO: Remove when done testing
        deck.append(JumpCard())
        deck.append(KnightLeftCard())
        deck.append(KnightRightCard())
        deck.append(DoubleDiagonalCard())
        deck.append(ZigZagLeftCard())
        deck.append(ZigZagRightCard())
        
        deck.append(BurnCard())
        deck.append(BurnCard())
        deck.append(ResurrectCard())
        deck.append(ResurrectCard())
    }
    
    func refill() throws {
        guard deck.count == 0 else { throw DeckError.deckNotEmpty }
        guard player.discard.count > 0 else { throw DiscardError.NothingDiscarded }
        
        deck.append(contentsOf: player.discard.cards)
        player.discard.cards.removeAll()
    }
    
    func draw() -> Card? {
        guard deck.count > 0 else { return nil }
        
        let randomIndex = Int(arc4random_uniform(UInt32(deck.count)))
        
        return deck.remove(at: randomIndex)
    }
}
