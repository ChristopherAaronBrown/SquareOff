//
//  SingleStraightCard.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class SingleStraightCard: Card, MovementCard {
    
    func getPaths(_ source: Coordinate) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertically
        if let target = try? Coordinate(column: source.column, row: source.row - 1) {
            paths.append(Path(coordinates: [source, target], movementCardType: type(of: self)))
        }
        
        // Try to append Path to left
        if let target = try? Coordinate(column: source.column - 1, row: source.row) {
            paths.append(Path(coordinates: [source, target], movementCardType: type(of: self)))
        }
        
        // Try to append Path to right
        if let target = try? Coordinate(column: source.column + 1, row: source.row) {
            paths.append(Path(coordinates: [source, target], movementCardType: type(of: self)))
        }
        
        return paths
    }
    
    init() {
        super.init(cost: 3)
    }
}
