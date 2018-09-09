//
//  SingleDiagonalCard.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class SingleDiagonalCard: Card, MovementCard {
    
    func getPaths(_ source: Coordinate) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertical-left
        if let target = try? Coordinate(column: source.column - 1, row: source.row - 1) {
            paths.append(Path(coordinates: [source, target], movementCardType: type(of: self)))
        }
        
        // Try to append Path vertical-right
        if let target = try? Coordinate(column: source.column + 1, row: source.row - 1) {
            paths.append(Path(coordinates: [source, target], movementCardType: type(of: self)))
        }
        
        return paths
    }
    
    init() {
        super.init(cost: 3)
    }
}
