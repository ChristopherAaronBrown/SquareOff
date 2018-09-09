//
//  GemCard.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class GemCard: Card, ActionCard {
    init(gem: Gem) {
        let cost: Int
        
        switch gem {
        case .Single:
            cost = 0
        case .Double:
            cost = 3
        case .Triple:
            cost = 6
        }
        
        super.init(cost: cost)
    }
}
