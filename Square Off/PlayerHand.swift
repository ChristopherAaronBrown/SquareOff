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
    
    var count: Int {
        return tiles.count
    }
    
    init() {
        self.limit = Constants.handLimit
        self.tiles = [Tile]()
    }
    
    func newHand(for player: Player) {
        
        // Remove old hand
        discardAllTiles(for: player)
        
        // Try to get a new hand
        do {
            while count < limit {
                if let tile = player.playerBag.draw() {
                    tiles.append(tile)
                } else {
                    try player.playerBag.refill(player.playerDiscard)
                }
            }
        } catch PlayerDiscardError.nothingDiscarded {
            print("\(player.name) has only \(count) total tile(s).")
        } catch { /* Do Nothing */ }
    }
    
    func containsType(_ type: Tile.Type) -> Bool {
        for tile in tiles {
            if type(of: tile) == type {
                return true
            }
        }
        return false
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
    
    func discardAllTiles(type: Tile.Type, for player: Player) {
        for index in stride(from: tiles.count - 1, through: 0, by: -1) {
            let tile = tiles[index]
            if type(of: tile) == type {
                player.playerDiscard.add(tiles[index])
                tiles.remove(at: index)
            }
        }
    }
    
    func discardAllTiles(for player: Player) {
        for tile in tiles {
            player.playerDiscard.add(tile)
        }
        tiles.removeAll()
    }
    
    func burnTile(at index: Int) {
        guard index < tiles.count else { return }
        
        tiles.remove(at: index)
    }
    
    func totalGems() -> Int {
        var total = 0
        for tile in tiles {
            if let gemTile = tile as? GemTile {
                total += gemTile.gem.rawValue
            }
        }
        return total
    }
}

extension PlayerHand: Sequence {
    func makeIterator() -> AnyIterator<Tile> {
        return AnyIterator(self.tiles.makeIterator())
    }
}
