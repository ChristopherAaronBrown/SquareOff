//
//  GemTile.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class GemTile: Tile {
    let value: Int
    
    init(value: Int) {
        self.value = value
        super.init(cost: ((value - 1) * 3), imageName: "Gem\(value)Tile")
    }
}