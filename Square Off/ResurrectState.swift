//
//  ResurrectState.swift
//  Square Off
//
//  Created by Chris Brown on 9/14/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import GameplayKit

class ResurrectState: GKState, SquareOffState {
    
    let session: GameSession
    var resurrectTile: ResurrectTile?
    
    init(session: GameSession) {
        self.session = session
    }
    
    override func didEnter(from previousState: GKState?) {
        let resurrectIndex = session.currentPlayer.playerHand.tiles.index(of: resurrectTile!)!
        session.currentPlayer.playerHand.tiles[resurrectIndex].color = session.colors.neutralColor
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is NeutralState.Type
    }
    
    // MARK: - SquareOffState Functions
    func boardSpaceTapped(at coordinate: BoardCoordinate) {
        let boardSpace = session.board.getBoardSpace(coordinate)
        if boardSpace.isHome(for: session.currentPlayer) && !boardSpace.isOccupied() {
            boardSpace.pawn = PlayerPawn(player: session.currentPlayer)
            session.currentPlayer.deadPawns -= 1
            
            let resurrectIndex = session.currentPlayer.playerHand.tiles.index(of: resurrectTile!)!
            session.currentPlayer.playerHand.removeTile(at: resurrectIndex, for: session.currentPlayer)
            
            self.stateMachine?.enter(NeutralState.self)
        }
    }
    
    func tileTapped(tile: Tile) {
        self.stateMachine?.enter(NeutralState.self)
    }
    
}
