//
//  JumpTile.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class JumpTile: Tile {
    init(player: Player) {
        let image = player.number == 0 ? #imageLiteral(resourceName: "JumpPink") : #imageLiteral(resourceName: "JumpGreen")
        super.init(player: player, cost: 4, image: image)
    }
}
