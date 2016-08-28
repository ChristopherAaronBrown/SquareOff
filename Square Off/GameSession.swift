//
//  GameSession.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class GameSession {
    
    let player1: Player
    let player2: Player
    let board: GameBoard
    var currentPlayer: Int
    
    init(player1: Player, player2: Player, board: GameBoard) {
        self.player1 = player1
        self.player2 = player2
        self.board = board
        currentPlayer = 0
    }
    
}