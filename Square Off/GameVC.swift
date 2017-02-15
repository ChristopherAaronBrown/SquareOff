//
//  GameVC.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

class GameVC: UIViewController, BoardViewDelegate, BoardViewDataSource, HandViewDelegate, HandViewDataSource {
    
    @IBOutlet weak var bagSlot: UIImageView!
    @IBOutlet weak var discardSlot: UIImageView!
    @IBOutlet weak var bagCount: UILabel!
    @IBOutlet weak var discardCount: UILabel!
    
    var boardView: BoardView!
    var handView: HandView!
    
    private var session: Session!
    private var longPressedPawn: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add board to view
        let boardXPos: CGFloat = 8
        let boardYPos: CGFloat = 60 + UIApplication.shared.statusBarFrame.height
        let boardWidth: CGFloat = view.bounds.width - 16
        let boardHeight: CGFloat = boardWidth * (77/76) // Ratio used for board image
        let boardFrame = CGRect(x: boardXPos, y: boardYPos, width: boardWidth, height: boardHeight)
        
        boardView = BoardView(frame: boardFrame)
        
        view.addSubview(boardView)
        
        boardView.delegate = self
        boardView.dataSource = self
        
        // Add hand to view
        let handWidth: CGFloat = view.bounds.width * (254/320)
        let handHeight: CGFloat = view.bounds.height * (58/568)
        let handXPos: CGFloat = (view.bounds.width - handWidth) / 2
        let handYPos: CGFloat = view.bounds.height * (400/568)

        let handFrame = CGRect(x: handXPos, y: handYPos, width: handWidth, height: handHeight)
        
        handView = HandView(frame: handFrame)
        
        view.addSubview(handView)
        
        handView.delegate = self
        handView.dataSource = self
        
        let player1 = Player(number: 0, name: "Chris")
        let player2 = Player(number: 1, name: "Greg")
        let board = Board(player1: player1, player2: player2)
        let session = Session(player1: player1, player2: player2, board: board)
        
        self.session = session
        
        refresh()
    }
    
    func refresh() {
        boardView.updateBoard()
        handView.setNeedsLayout()
        
        if session.currentPlayer.playerBag.count() > 0 {
            bagCount.isHidden = false
            bagCount.text = "\(session.currentPlayer.playerBag.count())"
            bagSlot.image = session.currentPlayer.number == 0 ? #imageLiteral(resourceName: "BagDiscardFilledPink") : #imageLiteral(resourceName: "BagDiscardFilledGreen")
        } else {
            bagCount.isHidden = true
            bagSlot.image = #imageLiteral(resourceName: "BagSlot")
        }
        
        if session.currentPlayer.playerDiscard.count() > 0 {
            discardCount.isHidden = false
            discardCount.text = "\(session.currentPlayer.playerDiscard.count())"
            discardSlot.image = session.currentPlayer.number == 0 ? #imageLiteral(resourceName: "BagDiscardFilledPink") : #imageLiteral(resourceName: "BagDiscardFilledGreen")
        } else {
            discardCount.isHidden = true
            discardSlot.image = #imageLiteral(resourceName: "DiscardSlot")
        }
    }
    
    @IBAction func endTurnPressed(_ sender: UIButton) {
        session.currentPlayer.playerHand.newHand(for: session.currentPlayer)
        session.currentPlayer = session.nextPlayerTurn()
        refresh()
    }
    
    // MARK: - BoardView delegate and data source functions
    func imageForSpace(at coordinate: BoardCoordinate) -> UIImage? {
        let modelCoordinate = session!.currentPlayer == session!.player1 ? coordinate : coordinate.inverse()
        
        return session!.board.getBoardSpace(modelCoordinate).pawn?.image
    }
    
    func highlightForSpace(at coordinate: BoardCoordinate) -> UIColor {
        let modelCoordinate = session.currentPlayer.number == 0 ? coordinate : coordinate.inverse()
        return session.board.getBoardSpace(modelCoordinate).highlight!
    }
    
    func boardSpaceTapped(at coordinate: BoardCoordinate) {
        
    }
    
    func pawnLongPressBegan(at coordinate: BoardCoordinate, with touchLocation: CGPoint) {
        let modelCoordinate = session.currentPlayer.number == 0 ? coordinate : coordinate.inverse()
        
        if session.board.getBoardSpace(modelCoordinate).isOccupied() {
            if session.board.getBoardSpace(modelCoordinate).pawn!.owner() == session.currentPlayer {
                
                highlightEligibleSpaces(at: modelCoordinate)
                
                session.board.getBoardSpace(modelCoordinate).pawn = nil
                if longPressedPawn == nil {
                    let imageWidth = view.bounds.size.width * (44/320) * 1.25
                    let imageHeight = view.bounds.size.height * (48/568) * 1.25
                    let xPos = touchLocation.x - imageWidth / 2
                    let yPos = touchLocation.y - imageHeight * 1.5
                    longPressedPawn = UIImageView(frame: CGRect(x: xPos, y: yPos, width: imageWidth, height: imageHeight))
                    longPressedPawn!.image = session.currentPlayer.number == 0 ? #imageLiteral(resourceName: "PawnPink") : #imageLiteral(resourceName: "PawnGreen")
                    
                    // Add shadow
                    longPressedPawn!.layer.shadowColor = Constants.colors.font.cgColor
                    longPressedPawn!.layer.shadowOpacity = 0.7
                    longPressedPawn!.layer.shadowOffset = CGSize(width: 0, height: imageHeight)
                    longPressedPawn!.layer.shadowRadius = 1.5
                    
                    self.view.addSubview(longPressedPawn!)
                }
                
                refresh()
            }
        }
    }
    
    func pawnLongPressChanged(at location: CGPoint) {
        let imageHeight = view.bounds.size.height * (48/568) * 1.25
        let xPos = location.x
        let yPos = location.y - imageHeight
        longPressedPawn?.center = CGPoint(x: xPos, y: yPos)
    }
    
    func pawnLongPressEnded(at targetBoardCoordinate: BoardCoordinate, from sourceBoardCoordinate: BoardCoordinate) {
        
        var coordinate: BoardCoordinate!
        
        if isEligibleTarget(targetBoardCoordinate) {
            coordinate = targetBoardCoordinate
            removeRequiredTiles(in: session.currentPlayer.playerHand, at: coordinate)
        } else {
            coordinate = sourceBoardCoordinate
        }
        
        if longPressedPawn != nil {
            longPressedPawn!.removeFromSuperview()
            longPressedPawn = nil
            
            let modelCoordinate = session.currentPlayer.number == 0 ? coordinate : coordinate.inverse()
            
            session.board.getBoardSpace(modelCoordinate!).pawn = PlayerPawn(player: session.currentPlayer)
            session.board.clearHighlights()
            
            
            
            refresh()
        }
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
            return PathAction.Move
        } else if enemies == 1 && allies == 0 && endOccupiedByEnemy {
            return PathAction.Attack
        } else if enemies == 1 && allies == 0 && !endOccupiedByEnemy {
            return PathAction.JumpOrAttack
        } else if (enemies >= 1 || allies >= 1) && !(endOccupiedByAlly || endOccupiedByEnemy) {
            return PathAction.Jump
        } else if (enemies >= 1 || (enemies == 1 && allies >= 1)) && endOccupiedByEnemy {
            return PathAction.JumpAndAttack
        } else {
            return PathAction.None
        }
        
    }
    
    func hasTile(_ desiredType: Tile.Type, in hand: PlayerHand) -> Bool {
        for tileInHand in hand {
            if type(of: tileInHand) == desiredType {
                return true
            }
        }
        return false
    }
    
    func highlightEligibleSpaces(at modelCoordinate: BoardCoordinate) {
        let hand = session.currentPlayer.playerHand
        
        // For each MovementTile getPaths at coordinate
        for tile in hand {
            if let movementTile = tile as? MovementTile {
                let paths = movementTile.getPaths(modelCoordinate, player: session.currentPlayer)
                
                for path in paths {
                    switch calcPathAction(path) {
                    case .Move:
                        session.board.getBoardSpace(path.end()).highlight = Constants.colors.blue
                    case .Attack:
                        if hasTile(AttackTile.self, in: hand) {
                            session.board.getBoardSpace(path.end()).highlight = Constants.colors.yellow
                        }
                    default:
                        break
                    }
                    session.board.getBoardSpace(path.end()).requiredMovementTile = type(of: tile)
                }
            }
        }
    }
    
    func removeRequiredTiles(in hand: PlayerHand, at coordinate: BoardCoordinate) {
        let modelCoordinate = session.currentPlayer.number == 0 ? coordinate : coordinate.inverse()
        let space = session.board.getBoardSpace(modelCoordinate)
        
        var requiredTiles: [Tile.Type] = [space.requiredMovementTile!]
        
        if space.highlight == Constants.colors.yellow {
            requiredTiles.append(AttackTile.self)
        }
        
        for tileType in requiredTiles {
            hand.discardTile(of: tileType, for: session.currentPlayer)
        }
    }
    
    func isEligibleTarget(_ target: BoardCoordinate) -> Bool {
        let modelCoordinate = session.currentPlayer.number == 0 ? target : target.inverse()
        
        let highlight = session.board.getBoardSpace(modelCoordinate).highlight
        
        let attack = highlight == Constants.colors.yellow && session.board.getBoardSpace(modelCoordinate).isOccupied()
        let movement = highlight == Constants.colors.blue && !session.board.getBoardSpace(modelCoordinate).isOccupied()
        
        return attack || movement
    }

    // MARK: - HandView delegate and data source functions
    func numberOfTiles() -> Int {
        return session.currentPlayer.playerHand.count()
    }
    
    func imageForTile(at index: Int) -> UIImage? {
        return session.currentPlayer.playerHand.tiles[index].image
    }
    
    func handViewSlotWasTapped(at index: Int) {

    }
    
    
}

