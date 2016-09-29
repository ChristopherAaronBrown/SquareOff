//
//  PlayerPawn.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class PlayerPawn {
    let player: Player
    let image: UIImage
    
    var hasReachedGoal: Bool
    
    init(player: Player) {
        self.player = player
        self.hasReachedGoal = false
        self.image = UIImage(named: "Player\(player.number + 1)Reverse")!
    }
    
    func owner() -> Player {
        return player
    }
}
