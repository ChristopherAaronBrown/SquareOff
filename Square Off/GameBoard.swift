//
//  GameBoard.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

class GameBoard {
    
    // 2D Array of GameBoardSpaces top left origin [column,row]
    let board: [[GameBoardSpace]]
    let player1Pawns: [PlayerPawn]
    let player2Pawns: [PlayerPawn]
    
    init() {
        player1Pawns = [PlayerPawn](count: 8, repeatedValue: PlayerPawn(playerNum: 0))
        player2Pawns = [PlayerPawn](count: 8, repeatedValue: PlayerPawn(playerNum: 1))
        
        var board = [[GameBoardSpace]]()
        
        // Build an empty game board
        for columnNum in 0...7 {
            var column = [GameBoardSpace]()
            for rowNum in 0...7 {
                let coordinate = try! BoardCoordinate(column: columnNum, row: rowNum)
                let gameBoardSpace = GameBoardSpace(coordinate: coordinate)
                
                if rowNum == 0 {
                    gameBoardSpace.setPawn(player2Pawns[columnNum])
                }
                
                if rowNum == 7 {
                    gameBoardSpace.setPawn(player1Pawns[columnNum])
                }
                
                column.append(gameBoardSpace)
            }
            board.append(column)
        }
        
        self.board = board
    }
    
    func getBoardSpace(coordinate: BoardCoordinate) -> GameBoardSpace {
        return board[coordinate.column][coordinate.row]
    }
}