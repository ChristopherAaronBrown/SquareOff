//
//  Path.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

struct Path {
    let coordinates: [BoardCoordinate]
    
    init(coordinates: [BoardCoordinate]) {
        self.coordinates = coordinates
    }
    
    func end() -> BoardCoordinate {
        return coordinates[coordinates.count - 1]
    }
}