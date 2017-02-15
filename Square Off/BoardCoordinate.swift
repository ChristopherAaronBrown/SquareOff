//
//  BoardCoordinate.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import Foundation

enum BoardCoordinateError: Error {
    case outOfBounds
}

struct BoardCoordinate: Hashable {
    let column: Int
    let row: Int
    
    var hashValue: Int {
        return column + row
    }
    
    init(column: Int, row: Int) throws {
        guard (column >= 0 && column < Constants.numberOfBoardSpaces) else { throw BoardCoordinateError.outOfBounds }
        guard (row >= 0 && row < Constants.numberOfBoardSpaces) else { throw BoardCoordinateError.outOfBounds }
        self.column = column
        self.row = row
    }
    
    func inverse() -> BoardCoordinate {
        return try! BoardCoordinate(column: (Constants.numberOfBoardSpaces - 1) - column,
                                    row: (Constants.numberOfBoardSpaces - 1) - row)
    }
}

func ==(lhs: BoardCoordinate, rhs: BoardCoordinate) -> Bool {
    return (lhs.column == rhs.column) && (lhs.row == rhs.row)
}
