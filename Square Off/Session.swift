//
//  Session.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class Session {
    
    let player1: Player
    let player2: Player
    let board: Board
    var currentPlayer: Player
    
    init(player1: Player, player2: Player, board: Board) {
        self.player1 = player1
        self.player2 = player2
        self.board = board
        currentPlayer = player1
    }
    
    func nextPlayerTurn() -> Player {
        currentPlayer = currentPlayer == player1 ? player2 : player1
        return currentPlayer
    }
    
}
