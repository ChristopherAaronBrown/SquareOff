//
//  Tile.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class Tile: Equatable {
    let cost: Int
    let imageName: String
    var color: UIColor?
    
    init(cost: Int, imageName: String) {
        self.cost = cost
        self.imageName = imageName
    }
}

func ==(lhs: Tile, rhs: Tile) -> Bool {
    return lhs === rhs
}
