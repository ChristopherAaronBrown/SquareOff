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
    
    func newHand(player: Player) {
        
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
        } catch PlayerDiscardError.NothingDiscarded {
            print("\(player.playerName) has only \(count()) total tile(s).")
        } catch { /* Do Nothing */ }
    }
    
    func count() -> Int {
        return tiles.count
    }
}