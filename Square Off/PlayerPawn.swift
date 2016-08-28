//
//  PlayerPawn.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class PlayerPawn {
    let playerNum: Int
    let pawnImage: UIImage
    
    var hasReachedGoal: Bool
    
    init(playerNum: Int) {
        self.playerNum = playerNum
        self.hasReachedGoal = false
        self.pawnImage = UIImage(named: "Player\(playerNum + 1)")!
    }
    
    func owner() -> Int {
        return self.playerNum
    }
}