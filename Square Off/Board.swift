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
    private var board: [[Space]]
    private let player1: Player
    private let player2: Player
    
    var count: Int {
        return board.count
    }
    
    var coordinatesDescription: String {
        var result = "Coordinates:\n"
        for row in 0..<count {
            for column in 0..<count {
                if column == count - 1 {
                    result += "\(board[column][row].description)\n"
                } else {
                    result += "\(board[column][row].description),"
                }
            }
        }
        return result
    }
    
    var pawnsDescription: String {
        var result = "Pawns:\n"
        for row in 0..<count {
            for column in 0..<count {
                if let pawn = board[column][row].pawn {
                    if column == count - 1 {
                        result += "[\(pawn.owner.number)]\n"
                    } else {
                        result += "[\(pawn.owner.number)],"
                    }
                } else {
                    if column == count - 1 {
                        result += "[_]\n"
                    } else {
                        result += "[_],"
                    }
                }
            }
        }
        return result
    }
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
        
        board = [[Space]]()
        
        for columnNum in 0..<Constants.numberOfSpaces {
            var column = [Space]()
            for rowNum in 0..<Constants.numberOfSpaces {
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
    }
    
    func getSpace(_ coordinate: Coordinate) -> Space {
        return board[coordinate.column][coordinate.row]
    }
    
    func hasOpenHomeSpot(player: Player) -> Bool {
        let row = player.number == 0 ? count - 1 : 0
        for column in 0..<count {
            if !board[column][row].isOccupied() {
                return true
            }
        }
        return false
    }
    
    // Coordinates remain but Pawns are rotated
    func rotateBoard() {
        var rotatedBoard = [[Space]]()
        for columnNum in 0..<count {
            var column = [Space]()
            for rowNum in 0..<count {
                let coordinate = try! Coordinate(column: columnNum, row: rowNum)
                let space = Space(coordinate: coordinate)
                let inversedColumn = count - 1 - columnNum
                let inversedRow = count - 1 - rowNum
                space.pawn = board[inversedColumn][inversedRow].pawn
                column.append(space)
            }
            rotatedBoard.append(column)
        }
        board = rotatedBoard
    }
    
}
