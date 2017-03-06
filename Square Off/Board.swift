//
//  Board.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class Board {
    
    // 2D Array of GameBoardSpaces top left origin [column,row]
    let board: [[BoardSpace]]
    let player1: Player
    let player2: Player
//    let highlight: [BoardSpace:UIColor]
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
        
        var board = [[BoardSpace]]()
        
        // Build an empty game board
        for columnNum in 0 ..< Constants.numberOfBoardSpaces {
            var column = [BoardSpace]()
            for rowNum in 0 ..< Constants.numberOfBoardSpaces {
                let coordinate = try! BoardCoordinate(column: columnNum, row: rowNum)
                let space = BoardSpace(coordinate: coordinate)
                
                switch rowNum {
                    case 0:
                        space.pawn = PlayerPawn(for: player2)
//                        highlight[space] = UIColor.clear
                    case Constants.numberOfBoardSpaces - 1:
                        space.pawn = PlayerPawn(for: player1)
//                        highlight[space] = UIColor.clear
                    default:
//                        highlight[space] = UIColor.clear
                        break
                }
                
                column.append(space)
            }
            board.append(column)
        }
        
        self.board = board
    }
    
//    func clearHighlights() {
//        for column in 0..<Constants.numberOfBoardSpaces {
//            for row in 0..<Constants.numberOfBoardSpaces {
//                let coordinate = try! BoardCoordinate(column: column, row: row)
//                let space = getBoardSpace(coordinate)
//                highlight[space] = UIColor.clear
//            }
//        }
//    }
    
    func getBoardSpace(_ coordinate: BoardCoordinate) -> BoardSpace {
        return board[coordinate.column][coordinate.row]
    }
}
