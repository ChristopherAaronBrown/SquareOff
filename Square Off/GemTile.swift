//
//  GemTile.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class GemTile: Tile {
    init(player: Player, gem: Constants.Gem) {
        let image: UIImage
        
        switch gem {
        case .Single:
            image = player.number == 0 ? #imageLiteral(resourceName: "SingleGemPink") : #imageLiteral(resourceName: "SingleGemGreen")
        case .Double:
            image = player.number == 0 ? #imageLiteral(resourceName: "DoubleGemPink") : #imageLiteral(resourceName: "DoubleGemGreen")
        case .Triple:
            image = player.number == 0 ? #imageLiteral(resourceName: "TripleGemPink") : #imageLiteral(resourceName: "TripleGemGreen")
        }
        
        super.init(player: player, cost: (gem.rawValue * (gem.rawValue + 1) / 2), image: image)
    }
}
