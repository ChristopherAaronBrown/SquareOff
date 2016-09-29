//
//  PlayOption.swift
//  Square Off
//
//  Created by Chris Brown on 9/19/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

struct PlayOption: Equatable, Hashable {
    
    let action: PathAction
    let path: Path
    let requiredTiles: [Tile]
    
    init(action: PathAction, path: Path, requiredTiles: [Tile]) {
        self.action = action
        self.path = path
        self.requiredTiles = requiredTiles
    }
    
    var hashValue: Int {
        return action.hashValue ^ path.end().hashValue
    }
}

func ==(lhs: PlayOption, rhs: PlayOption) -> Bool {
    return lhs.action == rhs.action && lhs.path.end() == rhs.path.end()
}

