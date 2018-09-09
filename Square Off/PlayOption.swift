//
//  PlayOption.swift
//  Square Off
//
//  Created by Chris Brown on 3/2/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import Foundation

class PlayOption {
    
    let path: Path
    let action: PathAction
    let requiredCards: [Card.Type]
    let description: String
    
    init(path: Path, action: PathAction, requiredCards: [Card.Type]) {
        self.path = path
        self.action = action
        self.requiredCards = requiredCards
        self.description = "- Path: \(path.description)\n- Action: \(action)\n"
    }
    
    func requiredCardTypes() -> [Card.Type] {
        var resultCardTypes: [Card.Type] = [path.requiredMovementCardType()]
        for cardType in requiredCards {
            if !resultCardTypes.contains(where: { (type) -> Bool in
                return cardType == type
            }) {
                resultCardTypes.append(cardType)
            }
        }
        return resultCardTypes
    }
    
}
