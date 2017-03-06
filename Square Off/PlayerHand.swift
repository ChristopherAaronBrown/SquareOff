//
//  PlayerHand.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class PlayerHand {
    let limit: Int
    
    var tiles: [Card]
    
    var count: Int {
        return tiles.count
    }
    
    var isEmpty: Bool {
        return tiles.isEmpty
    }
    
    init() {
        self.limit = Constants.handLimit
        self.tiles = [Card]()
    }
    
    func newHand(for player: Player) {
        
        // Remove old hand
        discardAllCards(for: player)
        
        // Try to get a new hand
        do {
            while count < limit {
                if let card = player.playerDeck.draw() {
                    tiles.append(card)
                } else {
                    try player.playerDeck.refill(player.playerDiscard)
                }
            }
        } catch PlayerDiscardError.nothingDiscarded {
            print("\(player.name) has only \(count) total card(s).")
        } catch { /* Do Nothing */ }
    }
    
    func containsType(_ type: Card.Type) -> Bool {
        for card in tiles {
            if type(of: card) == type {
                return true
            }
        }
        return false
    }
    
    func discardCard(of type: Card.Type, for player: Player) {
        for index in 0..<tiles.count {
            let card = tiles[index]
            if type(of: card) == type {
                player.playerDiscard.add(tiles[index])
                tiles.remove(at: index)
                break
            }
        }
    }
    
    func discardCard(at index: Int, for player: Player) {
        guard index < tiles.count else { return }
        
        player.playerDiscard.add(tiles[index])
        tiles.remove(at: index)
    }
    
    func discardAllCards(type: Card.Type, for player: Player) {
        for index in stride(from: tiles.count - 1, through: 0, by: -1) {
            let card = tiles[index]
            if type(of: card) == type {
                player.playerDiscard.add(tiles[index])
                tiles.remove(at: index)
            }
        }
    }
    
    func discardAllCards(for player: Player) {
        for card in tiles {
            player.playerDiscard.add(card)
        }
        tiles.removeAll()
    }
    
    func burnCard(at index: Int) {
        guard index < tiles.count else { return }
        
        tiles.remove(at: index)
    }
    
    func totalGems() -> Int {
        var total = 0
        for card in tiles {
            if let gemCard = card as? GemCard {
                total += gemCard.gem.rawValue
            }
        }
        return total
    }
}

extension PlayerHand: Sequence {
    func makeIterator() -> AnyIterator<Card> {
        return AnyIterator(self.tiles.makeIterator())
    }
}
