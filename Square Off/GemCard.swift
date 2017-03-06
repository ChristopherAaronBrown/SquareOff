//
//  GemCard.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class GemCard: Card, ActionCard {
    let gem: Gem!
    
    init(player: Player, gem: Gem) {
        let image: UIImage
        self.gem = gem
        
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
