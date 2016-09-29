//
//  Player.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class Player {
    let number: Int
    let name: String
    let direction: Int
    let color: UIColor
    
    var deadPawns: Int = 0
    var playerBag: PlayerBag
    var playerHand: PlayerHand
    var playerDiscard: PlayerDiscard
    
    init(playerNum: Int, playerName: String, color: UIColor) {
        self.number = playerNum
        self.name = playerName
        self.color = color
        direction = (playerNum == 0) ? 1 : -1
        playerBag = PlayerBag()
        playerHand = PlayerHand()
        playerDiscard = PlayerDiscard()
        
        // Draw first hand
        playerHand.newHand(for: self)
    }
    
}

func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.number == rhs.number
}
