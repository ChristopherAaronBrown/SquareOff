//
//  Card.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class Card: Equatable {
    let cost: Int
    let image: UIImage
    let player: Player
    
    init(player: Player, cost: Int, image: UIImage) {
        self.player = player
        self.cost = cost
        self.image = image
    }
}



func ==(lhs: Card, rhs: Card) -> Bool {
    return lhs === rhs
}
