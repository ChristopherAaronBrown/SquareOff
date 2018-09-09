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
    
    init(cost: Int) {
        self.cost = cost
    }
}

func ==(lhs: Card, rhs: Card) -> Bool {
    return lhs === rhs
}
