//
//  ResurrectTile.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class ResurrectTile: Tile {
    init(player: Player) {
        let image = player.number == 0 ? #imageLiteral(resourceName: "ResurrectPink") : #imageLiteral(resourceName: "ResurrectGreen")
        super.init(player: player, cost: 6, image: image)
    }
}
