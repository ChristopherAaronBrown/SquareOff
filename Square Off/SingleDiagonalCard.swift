//
//  SingleDiagonalCard.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class SingleDiagonalCard: Card, MovementCard {
    
    func getPaths(_ baseCoordinate: BoardCoordinate, player: Player) -> [Path] {
        var paths: [Path] = [Path]()
        
        // Try to append Path vertical-left
        if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column - 1,
                                                       row: baseCoordinate.row - (1 * player.direction)) {
            paths.append(Path(coordinates: [baseCoordinate, targetCoordinate], movementCardType: type(of: self)))
        }
        
        // Try to append Path vertical-right
        if let targetCoordinate = try? BoardCoordinate(column: baseCoordinate.column + 1,
                                                       row: baseCoordinate.row - (1 * player.direction)) {
            paths.append(Path(coordinates: [baseCoordinate, targetCoordinate], movementCardType: type(of: self)))
        }
        
        return paths
    }
    
    init(player: Player) {
        let image = player.number == 0 ? #imageLiteral(resourceName: "SingleDiagonalPink") : #imageLiteral(resourceName: "SingleDiagonalGreen")
        super.init(player: player, cost: 3, image: image)
    }
}
