//
//  GameVC.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

class GameVC: UIViewController,
              BoardViewDelegate, BoardViewDataSource,
              HandViewDelegate, HandViewDataSource,
              ShopVCDelegate, ShopVCDataSource {
    
    @IBOutlet weak var bagSlot: UIImageView!
    @IBOutlet weak var discardSlot: UIImageView!
    @IBOutlet weak var bagCount: UILabel!
    @IBOutlet weak var discardCount: UILabel!
    
    var boardView: BoardView!
    var handView: HandView!
    
    private var session: Session!
    private var longPressedPawn: UIImageView?
    
    private var requiredTileTypes: [BoardCoordinate:[Tile.Type]] = [:]
    private var eligiblePaths: [Path] = []
    private var highlightDict: [BoardCoordinate:UIColor] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // FIXME: Not checking for force touch capability
        // Check if user has 3D Touch
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: discardSlot)
        }
        
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
        handView.clipsToBounds = false
        
        view.addSubview(handView)
        
        handView.delegate = self
        handView.dataSource = self
        
        let player1 = Player(number: 0, name: "Chris")
        let player2 = Player(number: 1, name: "Greg")
        let board = Board(player1: player1, player2: player2)
        let session = Session(player1: player1, player2: player2, board: board)
        
        self.session = session
        view.bringSubview(toFront: bagCount)
        view.bringSubview(toFront: discardCount)
        
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        handView.animateDeal(from: bagSlot.center, callback: { _ in
//            // TODO: Decrement the bag counter
//        })
    }
    
    func refresh() {
        boardView.updateBoard()
        updateLabelCounts(for: session.currentPlayer)
    }
    
    private func updateLabelCounts(for player: Player) {
        if player.playerBag.count() > 0 {
            bagCount.isHidden = false
            bagCount.text = "\(player.playerBag.count())"
            bagSlot.image = player.number == 0 ? #imageLiteral(resourceName: "BagDiscardFilledPink") : #imageLiteral(resourceName: "BagDiscardFilledGreen")
        } else {
            bagCount.isHidden = true
            bagSlot.image = #imageLiteral(resourceName: "BagSlot")
        }
        
        if player.playerDiscard.count() > 0 {
            discardCount.isHidden = false
            discardCount.text = "\(player.playerDiscard.count())"
            discardSlot.image = player.number == 0 ? #imageLiteral(resourceName: "BagDiscardFilledPink") : #imageLiteral(resourceName: "BagDiscardFilledGreen")
        } else {
            discardCount.isHidden = true
            discardSlot.image = #imageLiteral(resourceName: "DiscardSlot")
        }
    }
    
    @IBAction func endTurnPressed(_ sender: UIButton) {
        let player = session.currentPlayer
        let hand = player.playerHand
        
        if hand.count() == 0 {
            hand.newHand(for: player)
            session.currentPlayer = session.nextPlayerTurn()
            refresh()
            handView.animateDeal(from: bagSlot.center, callback: { (_) in
                // TODO: Decrement the bag counter
            })
            return
        }
        
        handView.animateDiscard(to: discardSlot.center) { complete in
            // TODO: Increment the discard counter
//            self.updateLabelCounts(for: self.session.currentPlayer)
//            self.view.layoutIfNeeded()
            if complete {
                self.session.currentPlayer.playerHand.newHand(for: self.session.currentPlayer)
                self.session.currentPlayer = self.session.nextPlayerTurn()
                self.refresh()
                self.handView.animateDeal(from: self.bagSlot.center, callback: { (_) in
                    // TODO: Decrement the bag counter
                })
            }
        }
    }
    
    // MARK: - BoardView delegate and data source functions
    func imageForSpace(at coordinate: BoardCoordinate) -> UIImage? {
        let modelCoordinate = session!.currentPlayer == session!.player1 ? coordinate : coordinate.inverse()
        
        return session!.board.getBoardSpace(modelCoordinate).pawn?.image
    }
    
    func highlightForSpace(at coordinate: BoardCoordinate) -> UIColor {
        let modelCoordinate = session.currentPlayer.number == 0 ? coordinate : coordinate.inverse()
        
        if let highlight = highlightDict[modelCoordinate] {
            return highlight
        }
        
        return UIColor.clear
    }
    
    func pawnLongPressBegan(at coordinate: BoardCoordinate, with touchLocation: CGPoint) {
        let modelCoordinate = session.currentPlayer.number == 0 ? coordinate : coordinate.inverse()
        let space = session.board.getBoardSpace(modelCoordinate)
        
        // If user long presses one of their pawns
        if space.isOccupied() && space.pawn!.owner() == session.currentPlayer && !space.pawn!.hasReachedGoal {
            // Determine all eligible paths from the origin board space
            eligiblePaths = findEligiblePaths(at: modelCoordinate)
            
            highlightSpaces(for: eligiblePaths, at: modelCoordinate)
            
            session.board.getBoardSpace(modelCoordinate).pawn = nil
            if longPressedPawn == nil {
                let imageWidth = view.bounds.size.width * (44/320) * 1.25
                let imageHeight = view.bounds.size.height * (48/568) * 1.25
                let xPos = touchLocation.x - imageWidth / 2
                let yPos = touchLocation.y - imageHeight * 1.5
                longPressedPawn = UIImageView(frame: CGRect(x: xPos, y: yPos, width: imageWidth, height: imageHeight))
                longPressedPawn!.image = session.currentPlayer.number == 0 ? #imageLiteral(resourceName: "PawnPink") : #imageLiteral(resourceName: "PawnGreen")
                
                // Add shadow
                longPressedPawn!.layer.shadowColor = Colors.font.cgColor
                longPressedPawn!.layer.shadowOpacity = 0.7
                longPressedPawn!.layer.shadowOffset = CGSize(width: 0, height: imageHeight)
                longPressedPawn!.layer.shadowRadius = 1.5
                
                self.view.addSubview(longPressedPawn!)
            }
            
            refresh()
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
            removeRequiredTileTypes(at: coordinate)
        } else {
            coordinate = sourceBoardCoordinate
        }
        
        if longPressedPawn != nil {
            longPressedPawn!.removeFromSuperview()
            longPressedPawn = nil
            
            let modelCoordinate = session.currentPlayer.number == 0 ? coordinate : coordinate.inverse()
            let space = session.board.getBoardSpace(modelCoordinate!)
            
            space.pawn = PlayerPawn(player: session.currentPlayer)
            
            if space.isGoal(for: session.currentPlayer) {
                space.pawn!.hasReachedGoal = true
            }
            
            session.board.clearHighlights()
            
            requiredTileTypes = [:]
            highlightDict = [:]
            eligiblePaths = []
            
            refresh()
            handView.setNeedsLayout()
        }
    }
    
    // MARK: Helper functions
    func findEligiblePaths(at coordinate: BoardCoordinate) -> [Path] {
        var eligiblePaths: [Path] = []
        let hand = session.currentPlayer.playerHand
        
        /* For each movement tile in hand:
         - Get paths and check if hand has tiles required to perform path.
         - If so, add to eligible paths and add required tile to path end board space.
         - Then append all other tile types needed to perform that path.
        */
        for tile in hand {
            if let movementTile = tile as? MovementTile {
                let paths = movementTile.getPaths(coordinate, player: session.currentPlayer)
                for path in paths {
                    let (canPerform, tileTypes) = getPathAction(for: path).canPerform(with: hand)
                    if canPerform {
                        eligiblePaths.append(path)
                        if requiredTileTypes[path.end()] == nil {
                            requiredTileTypes[path.end()] = [type(of: tile)]
                        }
                        requiredTileTypes[path.end()]?.append(contentsOf: tileTypes)
                    }
                }
            }
        }
        return eligiblePaths
    }
    
    
    func getPathAction(for path: Path) -> PathAction {
        var enemies: Int = 0
        var allies: Int = -1
        var endOccupiedByEnemy: Bool = false
        var endOccupiedByAlly: Bool = false
        
        for coordinate in path {
            let space = session.board.getBoardSpace(coordinate)
            if let pawn = space.pawn {
                if pawn.owner() == session.currentPlayer || pawn.hasReachedGoal {
                    allies += 1
                } else {
                    enemies += 1
                }
            }
            if coordinate == path.end() && space.isOccupied() {
                if space.pawn!.owner() == session.currentPlayer {
                    endOccupiedByAlly = true
                } else {
                    endOccupiedByEnemy = true
                }
            }
        }
        
        if enemies == 0 && allies == 0 {
            return PathAction.Move
        } else if enemies == 1 && allies == 0 {
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
    
    func attackCoordinate(along path: Path) -> BoardCoordinate? {
        for coordinate in path {
            let space = session.board.getBoardSpace(coordinate)
            if space.isOccupied() {
                if space.pawn!.owner() !== session.currentPlayer {
                    return coordinate
                }
            }
        }
        
        return nil
    }
    
    func highlightSpaces(for paths: [Path], at modelCoordinate: BoardCoordinate) {
        for path in paths {
            switch getPathAction(for: path) {
            case .None:
                break
            case .Move:
                for coordinate in path {
                    if coordinate != path.beginning() {
                        highlightDict[coordinate] = coordinate == path.end() ? Colors.blueShadow : Colors.blue
                    }
                }
            case .Jump:
                highlightDict[path.end()] = Colors.blueShadow
            case .Attack:
                if let attack = attackCoordinate(along: path) {
                    for coordinate in path {
                        if coordinate == attack {
                            highlightDict[coordinate] = Colors.yellow
                        } else if coordinate != path.beginning() {
                            highlightDict[coordinate] = coordinate == path.end() ? Colors.blueShadow : Colors.blue
                        }
                    }
                }
            case .JumpAndAttack:
                highlightDict[path.end()] = Colors.yellow
            case .JumpOrAttack:
                if let attack = attackCoordinate(along: path) {
                    for coordinate in path {
                        if coordinate == attack {
                            highlightDict[coordinate] = Colors.yellow
                        } else if coordinate == path.end() {
                            highlightDict[coordinate] = Colors.blueShadow
                        }
                    }
                }
            }
        }
    }

    func removeRequiredTileTypes(at targetCoordinate: BoardCoordinate) {
        let modelCoordinate = session.currentPlayer.number == 0 ? targetCoordinate : targetCoordinate.inverse()
        
        for (coordinate,tileTypes) in requiredTileTypes {
            if coordinate == modelCoordinate {
                for tileType in tileTypes {
                    session.currentPlayer.playerHand.discardTile(of: tileType, for: session.currentPlayer)
                }
            }
        }
    }
    
    func isEligibleTarget(_ target: BoardCoordinate) -> Bool {
        let modelCoordinate = session.currentPlayer.number == 0 ? target : target.inverse()
        
        for path in eligiblePaths {
            if path.end() == modelCoordinate {
                return true
            }
        }
        
        return false
    }
    
    private func removeGems() {
        let player = session.currentPlayer
        let hand = player.playerHand
        
        hand.discardAllTiles(type: GemTile.self, for: player)
    }

    // MARK: - HandView delegate and data source functions
    func numberOfTiles() -> Int {
        return session.currentPlayer.playerHand.count()
    }
    
    func imageForTile(at index: Int) -> UIImage? {
        return session.currentPlayer.playerHand.tiles[index].image
    }
    
    func handViewSlotWasTapped(at index: Int) {
        let hand = session.currentPlayer.playerHand
        let tileType = type(of: hand.tiles[index])
        
        if tileType == GemTile.self {
            let shopVC = ShopVC()
            
            shopVC.datasource = self
            shopVC.delegate = self
            
            addChildViewController(shopVC)
            view.addSubview(shopVC.view)
            
            shopVC.didMove(toParentViewController: self)
            
        } else if tileType == ResurrectTile.self {
            // TODO: Implement resurrect
        }
        
    }
    
    // MARK: - ShopView datasource and delegate functions
    func currentPlayer() -> Player {
        return session.currentPlayer
    }
    
    func shopAnimationPoint() -> CGPoint {
        return handView.center
    }
    
    func purchased(tile: Tile) {
        let player = session.currentPlayer
        
        player.playerDiscard.add(tile)
        removeGems()
        
        handView.setNeedsLayout()
        refresh()
    }
}

