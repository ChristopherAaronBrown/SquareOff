//
//  Board.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class Board {
    
    // 2D Array of GameSpaces top left origin [column,row]
    var board: [[Space]]
    private let player1: Player
    private let player2: Player
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
        
        var board = [[Space]]()
        
        // Build an empty game board
        for columnNum in 0 ..< Constants.numberOfSpaces {
            var column = [Space]()
            for rowNum in 0 ..< Constants.numberOfSpaces {
                let coordinate = try! Coordinate(column: columnNum, row: rowNum)
                let space = Space(coordinate: coordinate)
                
                switch rowNum {
                    case 0:
                        space.pawn = Pawn(owner: player2)
                    case Constants.numberOfSpaces - 1:
                        space.pawn = Pawn(owner: player1)
                    default:
                        break
                }
                
                column.append(space)
            }
            board.append(column)
        }
        
        self.board = board
    }
    
    func getBoardSpace(_ coordinate: Coordinate) -> Space {
        return board[coordinate.column][coordinate.row]
    }
    
    func hasOpenHomeSpot(player: Player) -> Bool {
        let row = player.number == 0 ? Constants.numberOfSpaces - 1 : 0
        for column in 0 ..< Constants.numberOfSpaces {
            if !board[column][row].isOccupied() {
                return true
            }
        }
        return false
    }
    
    func rotateBoard() {
        var rotatedBoard = [[Space]]()
        for columnNum in (0 ..< board.count).reversed() {
            var column = [Space]()
            for rowNum in (0 ..< board[columnNum].count).reversed() {
                let coordinate = try! Coordinate(column: columnNum, row: rowNum)
                let space = Space(coordinate: coordinate)
                column.append(space)
            }
            rotatedBoard.append(column)
        }
        board = rotatedBoard
    }
    
}
