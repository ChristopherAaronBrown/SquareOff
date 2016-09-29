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
    
    func beginning() -> BoardCoordinate {
        return coordinates[0]
    }
    
    func count() -> Int {
        return coordinates.count
    }
    
    func containsCoordinate(_ coordinate: BoardCoordinate) -> Bool {
        for boardCoordinate in coordinates {
            if coordinate == boardCoordinate {
                return true
            }
        }
        return false
    }
}

extension Path: Sequence {
    func makeIterator() -> AnyIterator<BoardCoordinate> {
        return AnyIterator(self.coordinates.makeIterator())
    }
}

enum PathAction {
    case none
    case move
    case jump
    case attack
    case jumpAndAttack
    case jumpOrAttack
//    case moveOrAttack
//    case moveOrJump
}
