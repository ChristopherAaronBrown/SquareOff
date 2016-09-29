//
//  PlayerHand.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class PlayerHand {
    let limit: Int
    
    var tiles: [Tile]
    
    init() {
        self.limit = 5
        self.tiles = [Tile]()
    }
    
    func newHand(for player: Player) {
        
        // Add old hand tiles to PlayerDiscard
        for tile in tiles {
            player.playerDiscard.add(tile: tile)
        }
        
        // Remove old hand tiles
        tiles.removeAll()
        
        // Try to get a new hand
        do {
            while count() < limit {
                if let tile = player.playerBag.draw() {
                    tile.color = player.color
                    tiles.append(tile)
                } else {
                    try player.playerBag.refill(player.playerDiscard)
                }
            }
        } catch PlayerDiscardError.nothingDiscarded {
            print("\(player.name) has only \(count()) total tile(s).")
        } catch { /* Do Nothing */ }
    }
    
    func removeTile(at index: Int,for player: Player) {
        if index < tiles.count {
            player.playerDiscard.add(tile: tiles[index])
            tiles.remove(at: index)
        }
    }
    
    func burnTile(at index: Int) {
        if index < tiles.count {
            tiles.remove(at: index)
        }
    }
    
    func count() -> Int {
        return tiles.count
    }
}

extension PlayerHand: Sequence {
    func makeIterator() -> AnyIterator<Tile> {
        return AnyIterator(self.tiles.makeIterator())
    }
}
