//
//  BurnState.swift
//  Square Off
//
//  Created by Chris Brown on 9/14/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import GameplayKit

class BurnState: GKState, SquareOffState {
    
    let session: GameSession
    var burnTile: BurnTile?
    
    init(session: GameSession) {
        self.session = session
    }
    
    override func didEnter(from previousState: GKState?) {
        let burnIndex = session.currentPlayer.playerHand.tiles.index(of: burnTile!)!
        session.currentPlayer.playerHand.tiles[burnIndex].color = session.colors.neutralColor
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is NeutralState.Type
    }
    
    // MARK: - SquareOffState Functions
    func boardSpaceTapped(at coordinate: BoardCoordinate) {
        
    }
    
    func tileTapped(tile: Tile) {
        
        if tile != burnTile {
            let targetIndex = session.currentPlayer.playerHand.tiles.index(of: tile)!
            session.currentPlayer.playerHand.burnTile(at: targetIndex)
            let burnIndex = session.currentPlayer.playerHand.tiles.index(of: burnTile!)!
            session.currentPlayer.playerHand.removeTile(at: burnIndex, for: session.currentPlayer)
        }
        
        self.stateMachine?.enter(NeutralState.self)
    }
    
}
