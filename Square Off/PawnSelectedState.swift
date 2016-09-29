//
//  PawnSelectedState.swift
//  Square Off
//
//  Created by Chris Brown on 9/14/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit
import GameplayKit

class PawnSelectedState: GKState, SquareOffState {
    
    let session: GameSession
    var movementTile: Tile?
    var pawnSelected: BoardCoordinate?
    
    init(session: GameSession) {
        self.session = session
    }
    
//    override func didEnter(from previousState: GKState?) {
//        <#code#>
//    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is NeutralState.Type
    }
    
    override func willExit(to nextState: GKState) {
        session.playOptions = [:]
    }
    
    func attemptPlayOption(at coordinate: BoardCoordinate) {
        if boardSpaceInPlayOptionPath(coordinate).found {
            print(boardSpaceInPlayOptionPath(coordinate).paths)
        }
    }
    
    func boardSpaceInPlayOptionPath(_ coordinate: BoardCoordinate) -> (found: Bool, paths: [Path]?) {
        var paths: [Path] = []
        
        for (_, optionSet) in session.playOptions! {
            print("Option set: \(optionSet)")
            for option in optionSet {
                print("Option: \(option)")
                if option.path.containsCoordinate(coordinate) {
                    paths.append(option.path)
                }
            }
        }
        
        let found = paths.count > 0
        return (found, paths)
    }
    
    // MARK: - SquareOffState Functions
    // TODO: Use path instead of background colors
    func boardSpaceTapped(at coordinate: BoardCoordinate) {
        let tappedSpace = session.board.getBoardSpace(coordinate)
        
        attemptPlayOption(at: coordinate)
        
        if tappedSpace.pawn?.player.number == session.currentPlayer.number {
            self.stateMachine?.enter(MovementState.self)
        } else {
            if tappedSpace.backgroundColor == UIColor.yellow {
                tappedSpace.pawn = PlayerPawn(player: session.currentPlayer)
                session.board.getBoardSpace(pawnSelected!).pawn = nil
                
                let tileIndex = session.currentPlayer.playerHand.tiles.index(of: movementTile!)!
                session.currentPlayer.playerHand.removeTile(at: tileIndex, for: session.currentPlayer)
            } else if tappedSpace.backgroundColor == UIColor.magenta {
                
            }
            
            session.board.clearHighlights()
            self.stateMachine?.enter(NeutralState.self)
        }
        
    }
    
    func tileTapped(tile: Tile) {
        
    }
}
