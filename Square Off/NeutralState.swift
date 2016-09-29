//
//  NeutralState.swift
//  Square Off
//
//  Created by Chris Brown on 9/14/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import GameplayKit

class NeutralState: GKState, SquareOffState {
    
    let session: GameSession
    
    init(session: GameSession) {
        self.session = session
    }
    
    override func didEnter(from previousState: GKState?) {
        for tile in session.currentPlayer.playerHand.tiles {
            tile.color = session.currentPlayer.number == 0 ? session.colors.player1Color : session.colors.player2Color
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BurnState.Type || stateClass is MovementState.Type || stateClass is ResurrectState.Type
    }
    
    // MARK: - SquareOffState Functions
    func boardSpaceTapped(at coordinate: BoardCoordinate) {
        
    }
    
    func tileTapped(tile: Tile) {
        if let burnTile = tile as? BurnTile {
            self.stateMachine?.state(forClass: BurnState.self)?.burnTile = burnTile
            self.stateMachine?.enter(BurnState.self)
        } else if tile is MovementTile {
            self.stateMachine?.state(forClass: MovementState.self)?.movementTile = tile
            self.stateMachine?.enter(MovementState.self)
        } else if let resurrectTile = tile as? ResurrectTile {
            if session.currentPlayer.deadPawns > 0 {
                self.stateMachine?.state(forClass: ResurrectState.self)?.resurrectTile = resurrectTile
                self.stateMachine?.enter(ResurrectState.self)
            }
        }
    }
    
}
