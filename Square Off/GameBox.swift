//
//  GameBox.swift
//  Square Off
//
//  Created by Chris Brown on 8/9/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class GameBox {
    
    func purchase(gems: [GemTile], tile: Tile) -> Tile? {
        var totalGems: Int = 0
        
        for gem in 0 ..< gems.count {
            totalGems += gems[gem].value
        }
        
        return totalGems >= tile.cost ? tile : nil
    }
}
