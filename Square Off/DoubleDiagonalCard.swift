//
//  DoubleDiagonalCard.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class DoubleDiagonalCard: Card, MovementCard {
    
    func getPaths(_ source: Coordinate) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertical-left
        if  let second = try? Coordinate(column: source.column - 1, row: source.row - 1) {
            if let target = try? Coordinate(column: source.column - 2, row: source.row - 2) {
                paths.append(Path(coordinates: [source, second, target], movementCardType: type(of: self)))
            }
        }
        
        // Try to append Path vertical-right
        if  let second = try? Coordinate(column: source.column + 1, row: source.row - 1) {
            if let target = try? Coordinate(column: source.column + 2, row: source.row - 2) {
                paths.append(Path(coordinates: [source, second, target], movementCardType: type(of: self)))
            }
        }
        
        return paths
    }
    
    init() {
        super.init(cost: 5)
    }
}
