//
//  MainViewController.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit
import GameplayKit

class GameSpaceViewController: UIViewController, BoardViewDataSource, BoardViewDelegate,
                            HandViewDataSource, HandViewDelegate, StatusViewDataSource, StatusViewDelegate {
    
    fileprivate var session: GameSession
    var boardView: BoardView?
    var handView: HandView?
    var statusView: StatusView?
    var playerNameLabel: UILabel
    var stateMachine: GKStateMachine!
    
    // MARK: - Initializers
    init(session: GameSession) {
        self.session = session
        playerNameLabel = UILabel()
        
        stateMachine = GKStateMachine(states: [
            NeutralState(session: session),
            BurnState(session: session),
            MovementState(session: session),
            PawnSelectedState(session: session),
            ResurrectState(session: session),
            ShopState(session: session)
            ])
        stateMachine.enter(NeutralState.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        // Add player name
        let playerNameXPos: CGFloat = UIScreen.main.bounds.midX - 125
        let playerNameYPos: CGFloat = UIApplication.shared.statusBarFrame.height + 10
        playerNameLabel = UILabel(frame: CGRect(x: playerNameXPos, y: playerNameYPos, width: 250, height: 21))
        playerNameLabel.text = "\(session.player1.name)'s Turn"
        playerNameLabel.textAlignment = NSTextAlignment.center
        playerNameLabel.font = UIFont(name: "Anita-semi-square", size: 15)
        
        self.view.addSubview(playerNameLabel)
        
        // Add board to view
        let boardSize: CGFloat = UIScreen.main.bounds.width - 10
        let boardXPos: CGFloat = 5 + (boardSize.truncatingRemainder(dividingBy: 8)) / 2
        let boardYPos: CGFloat = playerNameYPos + playerNameLabel.bounds.height + boardXPos
        
        boardView = BoardView(frame: CGRect(x: boardXPos, y: boardYPos, width: boardSize, height: boardSize))
        
        boardView!.dataSource = self
        boardView!.delegate = self
        
        self.view.addSubview(boardView!)
        
        boardView?.updateBoard()
        
        // Add hand to view
        let handWidth: CGFloat = UIScreen.main.bounds.width
        let handHeight: CGFloat = (handWidth - 60) / 5
        let handXPos: CGFloat = 0
        let handYPos: CGFloat = boardYPos + boardSize + 15
        handView = HandView(frame: CGRect(x: handXPos, y: handYPos, width: handWidth, height: handHeight))
        
        handView!.dataSource = self
        handView!.delegate = self
        
        self.view.addSubview(handView!)
        
        // Add player status
        let statusXPos: CGFloat = 0
        let statusYPos: CGFloat = handYPos + handHeight + 10
        let statusWidth: CGFloat = handWidth
        let statusHeight: CGFloat = UIScreen.main.bounds.height - statusYPos
        statusView = StatusView(frame: CGRect(x: statusXPos, y: statusYPos, width: statusWidth, height: statusHeight))
        
        statusView!.dataSource = self
        statusView!.delegate = self
        
        self.view.addSubview(statusView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    func playerColor() -> UIColor {
        return session.currentPlayer.number == 0 ? session.colors.player1Color : session.colors.player2Color
    }
    
    func refresh() {
        boardView?.updateBoard()
        handView!.setNeedsLayout()
        statusView!.setNeedsLayout()
    }
    
    // MARK: - BoardViewDataSource
    func imageForSpace(at coordinate: BoardCoordinate) -> UIImage? {
        let modelCoordinate = session.currentPlayer == session.player1 ? coordinate : coordinate.inverse()
        
        return session.board.getBoardSpace(modelCoordinate).pawn?.image
    }
    
    func backgroundColorForSpace(at coordinate: BoardCoordinate) -> UIColor {
        let modelCoordinate = session.currentPlayer == session.player1 ? coordinate : coordinate.inverse()
//
//        return session.board.getBoardSpace(modelCoordinate).backgroundColor!
        
//        print("playOptions \(session.playOptions)")
//        print("modelCoordinate \(modelCoordinate)")
//        print("coordinate \(coordinate)")
        
        // TODO: Flush out later
        let option = session.playOptions?[modelCoordinate]?.first
        
        if option?.action == PathAction.move {
            return UIColor.yellow
        } else if option?.action == PathAction.attack {
            return UIColor.magenta
        } else if option?.action == PathAction.jump {
            return UIColor.cyan
        } else if option?.action == PathAction.jumpOrAttack {
            return UIColor.green
        } else if option?.action == PathAction.jumpAndAttack {
            return UIColor.purple
        } else {
            return UIColor.clear
        }
    }
    
    func tintForPawn(at coordinate: BoardCoordinate) -> UIColor? {
        let modelCoordinate = session.currentPlayer == session.player1 ? coordinate : coordinate.inverse()
        let boardSpace = session.board.getBoardSpace(modelCoordinate)
        
        guard boardSpace.isOccupied() else {
            return nil
        }
        
        return boardSpace.pawn?.player.number == 0 ? session.colors.player1Color : session.colors.player2Color
    }
    
    
    // TODO: Think of better way to represent colors on revealed paths. Highlight selected pawn
    // MARK: BoardViewDelegate
    func boardSpaceWasTapped(at coordinate: BoardCoordinate) {
        let modelCoordinate = session.currentPlayer == session.player1 ? coordinate : coordinate.inverse()
        
        if let currentState = self.stateMachine.currentState as? SquareOffState {
            currentState.boardSpaceTapped(at: modelCoordinate)
        }

//        if session.board.getBoardSpace(modelCoordinate).playerPawn?.player.number == session.currentPlayer.number {
//            if let movementTile = lastTappedTile as? MovementTile {
//                session.board.clearHighlights()
//                
//                let paths = movementTile.getPaths(baseCoordinate: modelCoordinate, player: session.currentPlayer)
//                
//                // Highlight paths
//                // Yellow:  Movement
//                // Magenta: Attack
//                // Cyan:    Jump
//                // Brown:   Jump & Attack
//                for path in paths {
//                    switch calcPathAction(path) {
//                    case PathAction.move:
//                        for space in path {
//                            if space == path.end() {
//                                session.board.getBoardSpace(space).backgroundColor = UIColor.yellow
//                            }
//                        }
//                    case PathAction.attack:
//                        if hasTileType(AttackTile.self) {
//                            for space in path {
//                                if space == path.end() {
//                                    session.board.getBoardSpace(space).backgroundColor = UIColor.magenta
//                                }
//                            }
//                        }
//                    case PathAction.jump:
//                        if hasTileType(JumpTile.self) {
//                            for space in path {
//                                if space == path.end() {
//                                    session.board.getBoardSpace(space).backgroundColor = UIColor.cyan
//                                }
//                            }
//                        }
//                    case PathAction.jumpOrAttack:
//                        if hasTileType(JumpTile.self) && !hasTileType(AttackTile.self) {
//                            for space in path {
//                                if space == path.end() {
//                                    session.board.getBoardSpace(space).backgroundColor = UIColor.cyan
//                                }
//                            }
//                        } else if !hasTileType(JumpTile.self) && hasTileType(AttackTile.self) {
//                            for space in path {
//                                if modelCoordinate != space {
//                                    if session.board.getBoardSpace(space).isOccupied() {
//                                        session.board.getBoardSpace(space).backgroundColor = UIColor.magenta
//                                    } else if space == path.end() {
//                                        session.board.getBoardSpace(space).backgroundColor = UIColor.yellow
//                                    }
//                                }
//                            }
//                        } else if hasTileType(JumpTile.self) && hasTileType(AttackTile.self) {
//                            for space in path {
//                                if modelCoordinate != space && space != path.end() {
//                                    if session.board.getBoardSpace(space).isOccupied() {
//                                        session.board.getBoardSpace(space).backgroundColor = UIColor.magenta
//                                    } else {
//                                        session.board.getBoardSpace(space).backgroundColor = UIColor.yellow
//                                    }
//                                } else if space == path.end() {
//                                    session.board.getBoardSpace(space).backgroundColor = UIColor.cyan
//                                }
//                            }
//                        }
//                        pathsRevealed = true
//                    case PathAction.jumpAndAttack:
//                        if hasTileType(JumpTile.self) && hasTileType(AttackTile.self) {
//                            for space in path {
//                                if space == path.end() {
//                                    session.board.getBoardSpace(space).backgroundColor = UIColor.brown
//                                }
//                            }
//                        }
//                    case PathAction.none:
//                        break
//                    }
//                }
//            }
//        }
        
        refresh()
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
        } else if (enemies >= 1 || (enemies == 1 && allies >= 1)) && endOccupiedByEnemy {
            return PathAction.jumpAndAttack
        } else {
            return PathAction.none
        }
        
    }
    
    // MARK: - HandViewDataSource
    func numberOfTiles() -> Int {
        return session.currentPlayer.playerHand.count()
    }
    
    func imageForTile(at index: Int) -> UIImage? {
        let imageName = session.currentPlayer.playerHand.tiles[index].imageName
        return UIImage(named: imageName)
    }
    
    func tintForTile(at index: Int) -> UIColor {
        return session.currentPlayer.playerHand.tiles[index].color!
    }
    
    func totalGemsInHand() -> Int {
        var total: Int = 0
        
        for tile in session.currentPlayer.playerHand {
            if let gem = tile as? GemTile {
                total += gem.value
            }
        }
        return total
    }
    
    // MARK: HandViewDelegate
    func handViewSlotWasTapped(at index: Int) {
        session.board.clearHighlights()
        
        if self.stateMachine.currentState == self.stateMachine.state(forClass: NeutralState.self) {
            if session.currentPlayer.playerHand.tiles[index] is GemTile {
                self.present(BoxViewController(totalGems: totalGemsInHand(), colors: session.colors, currentPlayer: session.currentPlayer), animated: true, completion: nil)
            }
        }
        
        if let currentState = self.stateMachine.currentState as? SquareOffState {
            currentState.tileTapped(tile: session.currentPlayer.playerHand.tiles[index])
        }
        
        refresh()
    }
    
    // MARK: - StatusViewDataSource
    func numTilesInBag() -> Int {
        return session.currentPlayer.playerBag.count()
    }
    
    func numTilesInDiscard() -> Int {
        return session.currentPlayer.playerDiscard.count()
    }
    
    // MARK: StatusViewDelegate
    func endTurnPressed() {
        session.board.clearHighlights()
        session.currentPlayer.playerHand.newHand(for: session.currentPlayer)
        session.currentPlayer = session.nextPlayerTurn()
        playerNameLabel.text = "\(session.currentPlayer.name)'s Turn"
        stateMachine.enter(NeutralState.self)
        
        refresh()
    }
}
