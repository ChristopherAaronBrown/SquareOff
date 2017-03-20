//
//  Player.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class Player {
    let number: Int
    let name: String
    
    var deadPawns: Int = 0
    var deck: Deck
    var hand: Hand
    var discard: Discard
    
    init(number: Int, name: String) {
        self.number = number
        self.name = name
        deck = Deck()
        hand = Hand()
        discard = Discard()
        
        // Draw first hand
        deck.player = self
        deck.populateInitialDeck()
    }
    
}

func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.number == rhs.number
}
