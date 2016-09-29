//
//  MovementState.swift
//  Square Off
//
//  Created by Chris Brown on 9/14/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import GameplayKit

class MovementState: GKState, SquareOffState {
    
    let session: GameSession
    var movementTile: Tile?
    
    init(session: GameSession) {
        self.session = session
    }
    
    override func didEnter(from previousState: GKState?) {
        let movementIndex = session.currentPlayer.playerHand.tiles.index(of: movementTile!)!
        session.currentPlayer.playerHand.tiles[movementIndex].color = session.colors.neutralColor
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PawnSelectedState.Type || stateClass is NeutralState.Type
    }
    
    func hasTileType(_ type: Tile.Type) -> Bool {
        for tile in session.currentPlayer.playerHand.tiles {
            if type(of: tile) === type {
                return true
            }
        }
        return false
    }
    
    func calcPathAction(_ path: Path) -> PathAction {
        var enemies: Int = 0
        var allies: Int = -1
        var endOccupiedByEnemy: Bool = false
        var endOccupiedByAlly: Bool = false
        
        for space in path {
            if let pawn = session.board.getBoardSpace(space).pawn {
                enemies += pawn.player.number == session.currentPlayer.number ? 0 : 1
                allies += pawn.player.number == session.currentPlayer.number ? 1 : 0
            }
            if space == path.end() && session.board.getBoardSpace(space).isOccupied()  {
                if session.board.getBoardSpace(space).pawn?.player.number != session.currentPlayer.number {
                    endOccupiedByEnemy = true
                } else {
                    endOccupiedByAlly = true
                }
            }
        }
        
        if enemies == 0 && allies == 0 {
            return PathAction.move
        } else if enemies == 1 && allies == 0 && endOccupiedByEnemy {
            return PathAction.attack
        } else if enemies == 1 && allies == 0 && !endOccupiedByEnemy {
            return PathAction.jumpOrAttack
        } else if (enemies >= 1 || allies >= 1) && !(endOccupiedByAlly || endOccupiedByEnemy) {
            return PathAction.jump
        } else if (enemies > 1 || (enemies == 1 && allies >= 1)) && endOccupiedByEnemy {
            return PathAction.jumpAndAttack
        } else {
            return PathAction.none
        }
        
    }
    
    func addOption(_ option: PlayOption, at coordinate: BoardCoordinate) {
        var options = session.playOptions?[coordinate] ?? Set<PlayOption>()
        print("Pre-insert: \(options)")
        options.insert(option)
        print("Post-insert: \(options)")
        session.playOptions?[coordinate] = options
    }
    
    // MARK: - SquareOffState Functions
    func boardSpaceTapped(at coordinate: BoardCoordinate) {
        if !session.board.getBoardSpace(coordinate).isGoal(for: session.currentPlayer) {
            if session.board.getBoardSpace(coordinate).pawn?.player.number == session.currentPlayer.number {
                if let tile = movementTile as? MovementTile {
                    session.playOptions = [:]
                    session.board.clearHighlights()
                    
                    let paths = tile.getPaths(baseCoordinate: coordinate, player: session.currentPlayer)
                    
                    // Highlight paths
                    // Yellow:  Movement
                    // Magenta: Attack
                    // Cyan:    Jump
                    // Brown:   Jump & Attack
                    for path in paths {
                        switch calcPathAction(path) {
                        case PathAction.move:
                            for space in path {
                                // TODO: do not need path.end()
//                                if space == path.end() {
//                                    session.board.getBoardSpace(space).backgroundColor = UIColor.yellow
//                                    let option = PlayOption(action: PathAction.move, path: path, requiredTiles: [movementTile!])
//                                    addOption(option, at: space)
//                                }
                                if space == path.end() {
                                    session.board.getBoardSpace(space).backgroundColor = UIColor.yellow
                                }
                            }
                            let option = PlayOption(action: PathAction.move, path: path, requiredTiles: [movementTile!])
                            addOption(option, at: coordinate)
                        case PathAction.attack:
                            if hasTileType(AttackTile.self) {
                                session.board.getBoardSpace(path.end()).backgroundColor = UIColor.magenta
                            }
                        case PathAction.jump:
                            if hasTileType(JumpTile.self) {
                                for space in path {
                                    if space == path.end() {
                                        session.board.getBoardSpace(space).backgroundColor = UIColor.cyan
                                    }
                                }
                            }
                        case PathAction.jumpOrAttack:
                            if hasTileType(JumpTile.self) && !hasTileType(AttackTile.self) {
                                for space in path {
                                    if space == path.end() {
                                        session.board.getBoardSpace(space).backgroundColor = UIColor.cyan
                                    }
                                }
                            } else if !hasTileType(JumpTile.self) && hasTileType(AttackTile.self) {
                                for space in path {
                                    if coordinate != space {
                                        if session.board.getBoardSpace(space).isOccupied() {
                                            session.board.getBoardSpace(space).backgroundColor = UIColor.magenta
                                        } else if space == path.end() {
                                            session.board.getBoardSpace(space).backgroundColor = UIColor.yellow
                                        }
                                    }
                                }
                            } else if hasTileType(JumpTile.self) && hasTileType(AttackTile.self) {
                                for space in path {
                                    if coordinate != space && space != path.end() {
                                        if session.board.getBoardSpace(space).isOccupied() {
                                            session.board.getBoardSpace(space).backgroundColor = UIColor.magenta
                                        } else {
                                            session.board.getBoardSpace(space).backgroundColor = UIColor.yellow
                                        }
                                    } else if space == path.end() {
                                        session.board.getBoardSpace(space).backgroundColor = UIColor.cyan
                                    }
                                }
                            }
                        case PathAction.jumpAndAttack:
                            if hasTileType(JumpTile.self) && hasTileType(AttackTile.self) {
                                for space in path {
                                    if space == path.end() {
                                        session.board.getBoardSpace(space).backgroundColor = UIColor.brown
                                    }
                                }
                            }
                        case PathAction.none:
                            break
                        }
                    }
                }
                self.stateMachine?.state(forClass: PawnSelectedState.self)?.pawnSelected = coordinate
                self.stateMachine?.state(forClass: PawnSelectedState.self)?.movementTile = movementTile
                self.stateMachine?.enter(PawnSelectedState.self)
            }
        }
    }
    
    func tileTapped(tile: Tile) {
        self.stateMachine?.enter(NeutralState.self)
    }
    
}
