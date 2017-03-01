//
//  PlayerPawn.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class PlayerPawn {
    let player: Player
    let image: UIImage
    
    var hasReachedGoal: Bool
    var owner: Player {
        return player
    }
    
    init(for player: Player) {
        self.player = player
        hasReachedGoal = false
        image = player.number == 0 ? #imageLiteral(resourceName: "PawnPink") : #imageLiteral(resourceName: "PawnGreen")
    }
}
