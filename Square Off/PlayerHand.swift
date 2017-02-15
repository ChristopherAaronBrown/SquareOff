//
//  PlayerHand.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class PlayerHand {
    let limit: Int
    
    var tiles: [Tile]
    
    init() {
        self.limit = Constants.handLimit
        self.tiles = [Tile]()
    }
    
    func newHand(for player: Player) {
        
        // Add old hand tiles to PlayerDiscard
        for tile in tiles {
            player.playerDiscard.add(tile)
        }
        
        // Remove old hand tiles
        tiles.removeAll()
        
        // Try to get a new hand
        do {
            while count() < limit {
                if let tile = player.playerBag.draw() {
                    tiles.append(tile)
                } else {
                    try player.playerBag.refill(player.playerDiscard)
                }
            }
        } catch PlayerDiscardError.nothingDiscarded {
            print("\(player.name) has only \(count()) total tile(s).")
        } catch { /* Do Nothing */ }
    }
    
    func discardTile(of type: Tile.Type, for player: Player) {
        for index in 0..<tiles.count {
            let tile = tiles[index]
            if type(of: tile) == type {
                player.playerDiscard.add(tiles[index])
                tiles.remove(at: index)
                break
            }
        }
    }
    
    func discardTile(at index: Int, for player: Player) {
        guard index < tiles.count else { return }
        
        player.playerDiscard.add(tiles[index])
        tiles.remove(at: index)
    }
    
    func burnTile(at index: Int) {
        guard index < tiles.count else { return }
        
        tiles.remove(at: index)
    }
    
    // Convenience function
    func count() -> Int {
        return tiles.count
    }
}

extension PlayerHand: Sequence {
    func makeIterator() -> AnyIterator<Tile> {
        return AnyIterator(self.tiles.makeIterator())
    }
}
