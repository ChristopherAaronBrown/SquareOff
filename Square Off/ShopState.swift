//
//  ShopState.swift
//  Square Off
//
//  Created by Chris Brown on 9/14/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import GameplayKit

class ShopState: GKState, SquareOffState {
    
    let session: GameSession
    
    init(session: GameSession) {
        self.session = session
    }
    
//    override func didEnter(from previousState: GKState?) {
//        <#code#>
//    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is NeutralState.Type
    }
    
    // MARK: - SquareOffState Functions
    func boardSpaceTapped(at coordinate: BoardCoordinate) {
        
    }
    
    func tileTapped(tile: Tile) {
        
    }
    
}
