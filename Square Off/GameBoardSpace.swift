//
//  GameBoardSpace.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

enum BoardCoordinateError: ErrorType {
    case OutOfBounds
}

struct BoardCoordinate: Hashable {
    let column: Int
    let row: Int
    
    var hashValue: Int {
        return column + row
    }
    
    init(column: Int, row: Int) throws {
        guard (column >= 0 && column < 8) else { throw BoardCoordinateError.OutOfBounds }
        guard (row >= 0 && row < 8) else { throw BoardCoordinateError.OutOfBounds }
        self.column = column
        self.row = row
    }
    
    func inverse() -> BoardCoordinate {
        return try! BoardCoordinate(column: 7 - column, row: 7 - row)
    }
}

func ==(lhs: BoardCoordinate, rhs: BoardCoordinate) -> Bool {
    return (lhs.column == rhs.column) && (lhs.row == rhs.row)
}

class GameBoardSpace {
    let coordinate: BoardCoordinate
    
    var playerPawn: PlayerPawn?
    
    init(coordinate: BoardCoordinate) {
        self.coordinate = coordinate
    }
    
    func occupyingPawn() -> PlayerPawn {
        return playerPawn!
    }
    
    func isOccupied() -> Bool {
        return (playerPawn != nil)
    }
    
    func isHome(player: Player) -> Bool {
        return (player.playerNum == 0) ? (coordinate.row == 0) : (coordinate.row == 7)
    }
    
    func isGoal(player: Player) -> Bool {
        return (player.playerNum == 0) ? (coordinate.row == 7) : (coordinate.row == 0)
    }
    
    func isHorizontalEdge() -> Bool {
        return (coordinate.row == 0 || coordinate.row == 7)
    }
    
    func isVerticalEdge() -> Bool {
        return (coordinate.column == 0 || coordinate.column == 7)
    }

    func isEdge() -> Bool {
        return (isHorizontalEdge() || isVerticalEdge())
    }
    
    func isCorner() -> Bool {
        return (isHorizontalEdge() && isVerticalEdge())
    }
    
}