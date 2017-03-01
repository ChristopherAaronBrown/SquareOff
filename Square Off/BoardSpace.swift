//
//  BoardSpace.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class BoardSpace {
    let coordinate: BoardCoordinate
    
    var highlight: UIColor?
    var pawn: PlayerPawn?
    var requiredMovementTile: Tile.Type?
    
    init(coordinate: BoardCoordinate) {
        self.coordinate = coordinate
    }
    
    func isOccupied() -> Bool {
        return pawn != nil
    }
    
    func isHome(for player: Player) -> Bool {
        return player.number == 0 ? coordinate.row == (Constants.numberOfBoardSpaces - 1) : coordinate.row == 0
    }
    
    func isGoal(for player: Player) -> Bool {
        return player.number == 0 ? coordinate.row == 0 : coordinate.row == (Constants.numberOfBoardSpaces - 1)
    }
    
    func isHorizontalEdge() -> Bool {
        return coordinate.row == 0 || coordinate.row == (Constants.numberOfBoardSpaces - 1)
    }
    
    func isVerticalEdge() -> Bool {
        return coordinate.column == 0 || coordinate.column == (Constants.numberOfBoardSpaces - 1)
    }

    func isEdge() -> Bool {
        return isHorizontalEdge() || isVerticalEdge()
    }
    
    func isCorner() -> Bool {
        return isHorizontalEdge() && isVerticalEdge()
    }
    
}
