//
//  Player.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class Player {
    let playerNum: Int
    let playerName: String
    let playerDirection: Int
    
    var playerBag: PlayerBag
    var playerHand: PlayerHand
    var playerDiscard: PlayerDiscard
    
    init(playerNum: Int, playerName: String) {
        self.playerNum = playerNum
        self.playerName = playerName
        playerDirection = (playerNum == 0) ? 1 : -1
        playerBag = PlayerBag()
        playerHand = PlayerHand()
        playerDiscard = PlayerDiscard()
    }
}