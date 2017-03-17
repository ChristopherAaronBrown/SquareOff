//
//  Hand.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class Hand {
    let limit: Int
    
    var cards: [Card]
    
    var count: Int {
        return cards.count
    }
    
    var isEmpty: Bool {
        return cards.isEmpty
    }
    
    init() {
        self.limit = Constants.handLimit
        self.cards = [Card]()
    }
    
    func newHand(for player: Player) {
        
        // Remove old hand
        discardAllCards(for: player)
        
        // Try to get a new hand
        do {
            while count < limit {
                if let card = player.deck.draw() {
                    cards.append(card)
                } else {
                    try player.deck.refill()
                }
            }
        } catch PlayerDiscardError.nothingDiscarded {
            print("\(player.name) has only \(count) total card(s).")
        } catch { /* Do Nothing */ }
    }
    
    func containsType(_ type: Card.Type) -> Bool {
        for card in cards {
            if type(of: card) == type {
                return true
            }
        }
        return false
    }
    
    func discardCard(of type: Card.Type, for player: Player) {
        for index in 0..<cards.count {
            let card = cards[index]
            if type(of: card) == type {
                player.discard.add(cards[index])
                cards.remove(at: index)
                break
            }
        }
    }
    
    func discardCard(at index: Int, for player: Player) {
        guard index < cards.count else { return }
        
        player.discard.add(cards[index])
        cards.remove(at: index)
    }
    
    func discardAllCards(type: Card.Type, for player: Player) {
        for index in stride(from: cards.count - 1, through: 0, by: -1) {
            let card = cards[index]
            if type(of: card) == type {
                player.discard.add(cards[index])
                cards.remove(at: index)
            }
        }
    }
    
    func discardAllCards(for player: Player) {
        for card in cards {
            player.discard.add(card)
        }
        cards.removeAll()
    }
    
    func burnCard(at index: Int) {
        guard index < cards.count else { return }
        
        cards.remove(at: index)
    }
    
    func totalGems() -> Int {
        var total = 0
        for card in cards {
            if let gemCard = card as? GemCard {
                total += (gemCard.cost / 3) + 1
            }
        }
        return total
    }
}
