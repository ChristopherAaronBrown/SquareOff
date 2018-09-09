//
//  Coordinate.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import Foundation

enum CoordinateError: Error {
    case outOfBounds
}

struct Coordinate: Hashable {
    let column: Int
    let row: Int
    
    var hashValue: Int {
        return column + row
    }
    
    var description: String {
        return "[\(column),\(row)]"
    }
    
    var inverse: Coordinate {
        return try! Coordinate(column: (Constant.numberOfSpaces - 1) - column, row: (Constant.numberOfSpaces - 1) - row)
    }
    
    init(column: Int, row: Int) throws {
        guard (column >= 0 && column < Constant.numberOfSpaces) else { throw CoordinateError.outOfBounds }
        guard (row >= 0 && row < Constant.numberOfSpaces) else { throw CoordinateError.outOfBounds }
        self.column = column
        self.row = row
    }
}

func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
    return (lhs.column == rhs.column) && (lhs.row == rhs.row)
}
