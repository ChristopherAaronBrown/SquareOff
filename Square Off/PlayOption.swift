//
//  PlayOption.swift
//  Square Off
//
//  Created by Chris Brown on 3/2/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import Foundation

class PlayOption {
    
    private var path: Path
    private var actions: [PathAction:[Card.Type]]
    
    init(path: Path, actions: [PathAction:[Card.Type]]) {
        self.path = path
        self.actions = actions
    }
    
    func requiredCardTypes() -> [Card.Type] {
        var resultCardTypes: [Card.Type] = [path.requiredMovementCardType()]
        for (_, tileTypes) in actions {
            for tileType in tileTypes {
                if !resultCardTypes.contains(where: { (type) -> Bool in
                    return tileType == type
                }) {
                    resultCardTypes.append(tileType)
                }
            }
        }
        return resultCardTypes
    }
    
}
