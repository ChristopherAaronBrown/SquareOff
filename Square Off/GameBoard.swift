//
//  GameBoard.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class GameBoard {
    
    // 2D Array of GameBoardSpaces top left origin [column,row]
    let board: [[GameBoardSpace]]
    let player1: Player
    let player2: Player
    let colors: ColorPairings
    
    init(player1: Player, player2: Player, colors: ColorPairings) {
        self.player1 = player1
        self.player2 = player2
        self.colors = colors
        
        var board = [[GameBoardSpace]]()
        
        // Build an empty game board
        for columnNum in 0...7 {
            var column = [GameBoardSpace]()
            for rowNum in 0...7 {
                let coordinate = try! BoardCoordinate(column: columnNum, row: rowNum)
                let space = GameBoardSpace(coordinate: coordinate)
                
                switch rowNum {
                    case 0:
                        space.pawn = PlayerPawn(player: player2)
                        space.backgroundColor = colors.neutralColor
                    case 7:
                        space.pawn = PlayerPawn(player: player1)
                        space.backgroundColor = colors.neutralColor
                    default:
                        space.backgroundColor = UIColor.clear
                }
                
                column.append(space)
            }
            board.append(column)
        }
        
//        // TODO: Remove when done testing
//        board[3][5].playerPawn = PlayerPawn(player: player1)
//        board[2][6].playerPawn = PlayerPawn(player: player1)
//        board[1][5].playerPawn = PlayerPawn(player: player2)
//        board[4][5].playerPawn = PlayerPawn(player: player2)
//        board[5][6].playerPawn = PlayerPawn(player: player2)
//        board[0][0].playerPawn = nil
        
        self.board = board
    }
    
    func clearHighlights() {
        for column in 0...7 {
            for row in 0...7 {
                let coordinate = try! BoardCoordinate(column: column, row: row)
                let space = getBoardSpace(coordinate)
                
                switch row {
                case 0, 7:
                    space.backgroundColor = colors.neutralColor
                default:
                    space.backgroundColor = UIColor.clear
                }
            }
        }
    }
    
    func getBoardSpace(_ coordinate: BoardCoordinate) -> GameBoardSpace {
        return board[coordinate.column][coordinate.row]
    }
}
