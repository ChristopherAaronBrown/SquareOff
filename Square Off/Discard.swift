//
//  Discard.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

enum DiscardError: Error {
    case NothingDiscarded
}

class Discard {
    var cards: [Card]
    
    var count: Int {
        return cards.count
    }
    
    init() {
        cards = [Card]()
    }
    
    func add(_ card: Card) {
        cards.append(card)
    }
}
