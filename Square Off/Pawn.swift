//
//  Pawn.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class Pawn {
    let owner: Player
    
    var hasReachedGoal: Bool
    
    init(owner: Player) {
        self.owner = owner
        hasReachedGoal = false
    }
}
