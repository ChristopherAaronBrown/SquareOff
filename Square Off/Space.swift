//
//  Space.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//


class Space {
    let coordinate: Coordinate
    
    var pawn: Pawn?
    var hasPawn: Bool {
        return pawn != nil
    }
    var description: String {
        return "[\(coordinate.column),\(coordinate.row)]"
    }
    var isHome: Bool {
        return coordinate.row == (Constant.numberOfSpaces - 1)
    }
    var isGoal: Bool {
        return coordinate.row == 0
    }
    var isOccupied: Bool {
        return pawn != nil
    }
    var isHorizontalEdge: Bool {
        return coordinate.row == 0 || coordinate.row == (Constant.numberOfSpaces - 1)
    }
    var isVerticalEdge: Bool {
        return coordinate.column == 0 || coordinate.column == (Constant.numberOfSpaces - 1)
    }
    var isEdge: Bool {
        return isHorizontalEdge || isVerticalEdge
    }
    var isCorner: Bool {
        return isHorizontalEdge && isVerticalEdge
    }
    init(coordinate: Coordinate) {
        self.coordinate = coordinate
    }
    
}
