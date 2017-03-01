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
              ShopVCDelegate, ShopVCDataSource,
              PathOptionVCDelegate, PathOptionVCDataSource {
    
    @IBOutlet weak var bagSlot: UIImageView!
    @IBOutlet weak var discardSlot: UIImageView!
    @IBOutlet weak var bagCount: UILabel!
    @IBOutlet weak var discardCount: UILabel!
    
    private var session: Session!
    private var boardView: BoardView!
    private var handView: HandView!
    private var player: Player {
        get {
            return session.currentPlayer
        }
        set {
            session.currentPlayer = newValue
        }
    }
    private var opponent: Player {
        return player.number == 0 ? session.player2 : session.player1
    }
    private var board: Board {
        return session.board
    }
    private var hand: PlayerHand {
        return player.playerHand
    }
    private var bag: PlayerBag {
        return player.playerBag
    }
    private var discard: PlayerDiscard {
        return player.playerDiscard
    }
    private var longPressedPawn: UIImageView?
    private var requiredTileTypes: [BoardCoordinate:[Tile.Type]] = [:]
    private var eligiblePaths: [Path] = []
    private var highlightDict: [BoardCoordinate:UIColor] = [:]
    private var pathOptions: [PathAction] = []
    private var pathActionChosen: PathAction = .None
    private var state: State = .Normal
    
    
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
        
        player2.playerHand.newHand(for: player2)
        refresh()
        handView.refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hand.newHand(for: player)
        handView.animateDeal(from: bagSlot.center, callback: { _ in
            self.updateLabelCounts()
        })
    }
    
    private func refresh() {
        setNextState(.Normal)
        boardView.updateBoard()
        updateLabelCounts()
    }
    
    private func updateLabelCounts() {
        if bag.count > 0 {
            bagCount.isHidden = false
            bagCount.text = "\(bag.count)"
            bagSlot.image = player.number == 0 ? #imageLiteral(resourceName: "BagDiscardFilledPink") : #imageLiteral(resourceName: "BagDiscardFilledGreen")
        } else {
            bagCount.isHidden = true
            bagSlot.image = #imageLiteral(resourceName: "BagSlot")
        }
        
        if player.playerDiscard.count > 0 {
            discardCount.isHidden = false
            discardCount.text = "\(player.playerDiscard.count)"
            discardSlot.image = player.number == 0 ? #imageLiteral(resourceName: "BagDiscardFilledPink") : #imageLiteral(resourceName: "BagDiscardFilledGreen")
        } else {
            discardCount.isHidden = true
            discardSlot.image = #imageLiteral(resourceName: "DiscardSlot")
        }
    }
    
    @IBAction func endTurnPressed(_ sender: UIButton) {
        if hand.count == 0 {
            hand.newHand(for: player)
            session.currentPlayer = session.nextPlayerTurn()
            refresh()
            handView.animateDeal(from: bagSlot.center, callback: { (_) in
                self.updateLabelCounts()
            })
            return
        }
        
        handView.animateDiscard(to: discardSlot.center) { complete in
            self.updateLabelCounts()
            if complete {
                self.hand.newHand(for: self.session.currentPlayer)
                self.player = self.session.nextPlayerTurn()
                self.refresh()
                self.handView.animateDeal(from: self.bagSlot.center, callback: { (_) in
                    self.updateLabelCounts()
                })
            }
        }
    }
    
    // MARK: - BoardView delegate and data source functions
    func imageForSpace(at coordinate: BoardCoordinate) -> UIImage? {
        let modelCoordinate = player.number == 0 ? coordinate : coordinate.inverse()
        
        return board.getBoardSpace(modelCoordinate).pawn?.image
    }
    
    func highlightForSpace(at coordinate: BoardCoordinate) -> UIColor {
        let modelCoordinate = player.number == 0 ? coordinate : coordinate.inverse()
        
        if let highlight = highlightDict[modelCoordinate] {
            return highlight
        }
        
        return UIColor.clear
    }
    
    func boardSpaceTapped(at coordinate: BoardCoordinate) {
        let modelCoordinate = player.number == 0 ? coordinate : coordinate.inverse()
        let space = board.getBoardSpace(modelCoordinate)
        
        if state == .ResurrectTileTapped && space.isHome(for: player) && !space.isOccupied() {
            space.pawn = PlayerPawn(for: player)
            player.deadPawns -= 1
            hand.discardTile(of: ResurrectTile.self, for: player)
            highlightDict = [:]
            handView.refresh()
            refresh()
        }
    }
    
    func pawnLongPressBegan(at coordinate: BoardCoordinate, with touchLocation: CGPoint) {
        let modelCoordinate = player.number == 0 ? coordinate : coordinate.inverse()
        let space = board.getBoardSpace(modelCoordinate)
        
        // If user long presses one of their pawns
        if space.isOccupied() && space.pawn!.owner == player && !space.pawn!.hasReachedGoal {
            setNextState(.Normal)
            
            // Determine all eligible paths from the origin board space
            eligiblePaths = findEligiblePaths(at: modelCoordinate)
            
            highlightSpaces(for: eligiblePaths, at: modelCoordinate)
            
            board.getBoardSpace(modelCoordinate).pawn = nil
            if longPressedPawn == nil {
                let imageWidth = view.bounds.size.width * (44/320) * 1.25
                let imageHeight = view.bounds.size.height * (48/568) * 1.25
                let xPos = touchLocation.x - imageWidth / 2
                let yPos = touchLocation.y - imageHeight * 1.5
                longPressedPawn = UIImageView(frame: CGRect(x: xPos, y: yPos, width: imageWidth, height: imageHeight))
                longPressedPawn!.image = player.number == 0 ? #imageLiteral(resourceName: "PawnPink") : #imageLiteral(resourceName: "PawnGreen")
                
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
        
        let target = player.number == 0 ? targetBoardCoordinate : targetBoardCoordinate.inverse()
        let source = player.number == 0 ? sourceBoardCoordinate : sourceBoardCoordinate.inverse()
        let pathOptions = pathsEnding(at: target)
        
        if pathOptions.isEmpty {
            placePawn(at: source)
        } else if pathOptions.count == 1 {
            attemptPawnPlacement(along: pathOptions[0], from: source, to: target)
        } else {
            // Prompt user for which path to use
            promptUser(for: pathOptions) { chosenPathOption in
                attemptPawnPlacement(along: chosenPathOption, from: source, to: target)
            }
        }
    }
    
    // MARK: Helper functions
    private func promptUser(for paths: [Path], callback: (Path) -> Void) {
        var chosenPath: Path!
        
//        for path in paths {
//            pathOptions.append(getPathAction(for: path))
//        }
//        
//        if (pathOptions.contains(.Attack) || pathOptions.contains(.JumpAndAttack)) {
//            let pathOptionVC = PathOptionVC()
//            
//            pathOptionVC.dataSource = self
//            pathOptionVC.delegate = self
//            
//            addChildViewController(pathOptionVC)
//            view.addSubview(pathOptionVC.view)
//            
//            pathOptionVC.didMove(toParentViewController: self)
//            
//            for path in paths {
//                if getPathAction(for: path) == pathActionChosen {
//                    chosenPath = path
//                    break
//                } else {
//                    chosenPath = paths[0]
//                }
//            }
//            
//            print(chosenPath)
//            
//            pathActionChosen = .None
//            
//        } else {
//            chosenPath = paths[0]
//        }
        
        for path in paths {
            if getPathAction(for: path) == .Attack {
                chosenPath = path
                break
            } else {
                chosenPath = paths[0]
            }
        }
        
        callback(chosenPath)
    }
    
    private func attemptPawnPlacement(along path: Path, from source: BoardCoordinate, to target: BoardCoordinate) {
        var usedTileTypes: [Tile.Type] = [path.requiredMovementTileType()]
        
        switch getPathAction(for: path) {
        case .JumpAndAttack:
            if opponent.playerHand.containsType(DefendTile.self) {
                showDefendAnimation(for: opponent)
                opponent.playerHand.discardTile(of: DefendTile.self, for: opponent)
                placePawn(at: source)
            } else {
                placePawn(at: target)
                opponent.deadPawns += 1
            }
            usedTileTypes.append(JumpTile.self)
            usedTileTypes.append(AttackTile.self)
        case .Attack:
            if opponent.playerHand.containsType(DefendTile.self) {
                showDefendAnimation(for: opponent)
                opponent.playerHand.discardTile(of: DefendTile.self, for: opponent)
                let pawnCoordinate = attackCoordinate(along: path)!
                let closest = path.closest(coordinate: pawnCoordinate)
                placePawn(at: closest)
            } else {
                placePawn(at: target)
            }
            usedTileTypes.append(AttackTile.self)
        case .Jump:
            placePawn(at: target)
            usedTileTypes.append(JumpTile.self)
        case .Move:
            placePawn(at: target)
        default:
            break
        }
        removeUsedTiles(in: usedTileTypes)
    }
    
    private func showDefendAnimation(for player: Player) {
        let backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = UIColor.white
        backgroundView.alpha = 0
        
        view.addSubview(backgroundView)
        view.bringSubview(toFront: backgroundView)
        
        let width: CGFloat = view.bounds.width * (165/320)
        let height: CGFloat = view.bounds.height * (180/568)
        let xPos: CGFloat = view.bounds.midX - width / 2
        let yPos: CGFloat = height * -1
        let frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        let defendImageView = UIImageView(frame: frame)
        
        defendImageView.image = player.number == 0 ? #imageLiteral(resourceName: "DefendBigPink") : #imageLiteral(resourceName: "DefendBigGreen")
        defendImageView.backgroundColor = UIColor.clear
        
        view.addSubview(defendImageView)
        view.bringSubview(toFront: defendImageView)
        
        let origin = frame.center
        let destination = CGPoint(x: frame.midX, y: height * 1.25)
        let duration: TimeInterval = 0.3
        let delay: TimeInterval = 0.75
        
        UIView.animate(withDuration: duration, animations: {
            defendImageView.center = destination
            backgroundView.alpha = 0.7
        }) { (complete) in
            
            if complete {
                UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
                    defendImageView.center = origin
                    backgroundView.alpha = 0
                }, completion: { (complete) in
                    defendImageView.removeFromSuperview()
                    backgroundView.removeFromSuperview()
                })
            }
        }
    }
    
    private func placePawn(at modelCoordinate: BoardCoordinate) {
        if longPressedPawn != nil {
            longPressedPawn!.removeFromSuperview()
            longPressedPawn = nil

            let space = board.getBoardSpace(modelCoordinate)

            if space.isOccupied() && space.pawn!.owner !== player {
                space.pawn!.owner.deadPawns += 1
            }

            space.pawn = PlayerPawn(for: player)

            if space.isGoal(for: player) {
                space.pawn!.hasReachedGoal = true
            }

            board.clearHighlights()

            requiredTileTypes = [:]
            highlightDict = [:]
            eligiblePaths = []
            
            refresh()
            handView.refresh()
        }
    }
    
    private func removeUsedTiles(in usedTileTypes: [Tile.Type]) {
        for tileType in usedTileTypes {
            hand.discardTile(of: tileType, for: player)
        }
        handView.refresh()
        refresh()
    }
    
    private func findEligiblePaths(at coordinate: BoardCoordinate) -> [Path] {
        var eligiblePaths: [Path] = []
        
        /* For each movement tile in hand:
         - Get paths and check if hand has tiles required to perform path.
         - If so, add to eligible paths and add required tile to path end board space.
         - Then append all other tile types needed to perform that path.
        */
        for tile in hand {
            if let movementTile = tile as? MovementTile {
                let paths = movementTile.getPaths(coordinate, player: player)
                for path in paths {
                    let (canPerform, tileTypes) = getPathAction(for: path).canPerform(with: hand)
                    if canPerform {
                        eligiblePaths.append(path)
                        if requiredTileTypes[path.end] == nil {
                            requiredTileTypes[path.end] = [type(of: tile)]
                        }
                        requiredTileTypes[path.end]?.append(contentsOf: tileTypes)
                    }
                }
            }
        }
        return eligiblePaths
    }
    
    private func pathsEnding(at target: BoardCoordinate) -> [Path] {
        var paths: [Path] = []
        
        for path in eligiblePaths {
            if path.end == target {
                paths.append(path)
            }
        }
        
        return paths
    }
    
    private func getPathAction(for path: Path) -> PathAction {
        var enemies: Int = 0
        var allies: Int = 0
        var endOccupiedByEnemy: Bool = false
        var endOccupiedByAlly: Bool = false
        
        for coordinate in path {
            let space = board.getBoardSpace(coordinate)
            if coordinate != path.beginning {
                if let pawn = space.pawn {
                    if pawn.owner == player || pawn.hasReachedGoal {
                        allies += 1
                    } else {
                        enemies += 1
                    }
                }
            }
            if coordinate == path.end && space.isOccupied() {
                if space.pawn!.owner == player {
                    endOccupiedByAlly = true
                } else {
                    endOccupiedByEnemy = true
                }
            }
        }
        
        let endUnoccupied = !(endOccupiedByEnemy || endOccupiedByAlly)
        
        if path.count == 2 {
            if endOccupiedByEnemy {
                return .Attack
            } else if endUnoccupied {
                return .Move
            } else {
                return .None
            }
        } else if path.count == 3 {
            if endOccupiedByEnemy && (enemies > 1 || allies == 1) {
                return .JumpAndAttack
            } else if endUnoccupied && (enemies == 1 && allies == 0) {
                return .JumpOrAttack
            } else if enemies == 1 && allies == 0 {
                return .Attack
            } else if endUnoccupied && (enemies == 0 && allies == 1) {
                return .Jump
            } else if enemies == 0 && allies == 0 {
                return .Move
            } else {
                return .None
            }
        } else {
            if endOccupiedByEnemy && (enemies > 1 || allies >= 1) {
                return .JumpAndAttack
            } else if endUnoccupied && (enemies == 1 && allies == 0) {
                return .JumpOrAttack
            } else if endUnoccupied && (enemies > 1 || allies >= 1) {
                return .Jump
            } else if enemies == 1 && allies == 0 {
                return .Attack
            } else if enemies == 0 && allies == 0 {
                return .Move
            } else {
                return .None
            }
        }
    }
    
    private func attackCoordinate(along path: Path) -> BoardCoordinate? {
        for coordinate in path {
            let space = board.getBoardSpace(coordinate)
            if space.isOccupied() {
                if space.pawn!.owner !== player {
                    return coordinate
                }
            }
        }
        
        return nil
    }
    
    private func highlightSpaces(for paths: [Path], at modelCoordinate: BoardCoordinate) {
        for path in paths {
            switch getPathAction(for: path) {
            case .None:
                break
            case .Move:
                for coordinate in path {
                    if coordinate != path.beginning && (highlightDict[coordinate] != Colors.blueShadow || highlightDict[coordinate] != Colors.yellow) {
                        highlightDict[coordinate] = coordinate == path.end ? Colors.blueShadow : Colors.blue
                    }
                }
            case .Jump:
                highlightDict[path.end] = Colors.blueShadow
            case .Attack:
                if let attack = attackCoordinate(along: path) {
                    for coordinate in path {
                        if coordinate == attack {
                            highlightDict[coordinate] = Colors.yellow
                        } else if coordinate != path.beginning && (highlightDict[coordinate] != Colors.blueShadow || highlightDict[coordinate] != Colors.yellow) {
                            highlightDict[coordinate] = coordinate == path.end ? Colors.blueShadow : Colors.blue
                        }
                    }
                }
            case .JumpAndAttack:
                highlightDict[path.end] = Colors.yellow
            case .JumpOrAttack:
                if let attack = attackCoordinate(along: path) {
                    for coordinate in path {
                        if coordinate == attack {
                            highlightDict[coordinate] = Colors.yellow
                        } else if coordinate == path.end {
                            highlightDict[coordinate] = Colors.blueShadow
                        } else if coordinate != path.beginning && (highlightDict[coordinate] != Colors.blueShadow || highlightDict[coordinate] != Colors.yellow) {
                            highlightDict[coordinate] = Colors.blue
                        }
                    }
                }
            }
        }
    }

    private func isEligibleTarget(_ target: BoardCoordinate) -> Bool {
        for path in eligiblePaths {
            if path.end == target {
                return true
            }
        }
        
        return false
    }
    
    private func removeGems() {
        hand.discardAllTiles(type: GemTile.self, for: player)
    }

    // MARK: - HandView delegate and data source functions
    func numberOfTiles() -> Int {
        return hand.count
    }
    
    func imageForTile(at index: Int) -> UIImage? {
        return hand.tiles[index].image
    }
    
    func handViewSlotWasTapped(at index: Int) {
        let tileType = type(of: hand.tiles[index])
        
        if tileType == GemTile.self {
            let shopVC = ShopVC()
            
            shopVC.dataSource = self
            shopVC.delegate = self
            
            addChildViewController(shopVC)
            view.addSubview(shopVC.view)
            
            shopVC.didMove(toParentViewController: self)
            
        } else if tileType == ResurrectTile.self && player.deadPawns > 0 {
            setNextState(.ResurrectTileTapped)
            highlightResurrectSpaces()
        }
        
    }
    
    private func setNextState(_ nextState: State) {
        state = nextState
        switch state {
        case .Normal:
            break
        case .ResurrectTileTapped:
            break
        }
    }
    
    private func highlightResurrectSpaces() {
        for homeSpaceCoordinate in homeSpacesAvailable() {
            highlightDict[homeSpaceCoordinate] = Colors.yellow
        }
        boardView.updateBoard()
    }
    
    private func homeSpacesAvailable() -> [BoardCoordinate] {
        var homeSpaceCoordinates: [BoardCoordinate] = []
        let row = player.number == 0 ? Constants.numberOfBoardSpaces - 1 : 0
        
        for col in 0..<Constants.numberOfBoardSpaces {
            let coordinate = try! BoardCoordinate(column: col, row: row)
            let space = board.getBoardSpace(coordinate)
            if space.isHome(for: player) && !space.isOccupied() {
                homeSpaceCoordinates.append(space.coordinate)
            }
        }
        
        return homeSpaceCoordinates
    }
    
    // MARK: - ShopVC delegate and data source functions
    func currentPlayer() -> Player {
        return player
    }
    
    func shopAnimationPoint() -> CGPoint {
        return handView.center
    }
    
    func purchased(tile: Tile) {
        discard.add(tile)
        removeGems()
        
        handView.refresh()
        refresh()
    }
    
    // MARK: - PathOptionVC delegate and data source functions
    func chosenAction(action: PathAction) {
        pathActionChosen = action
    }
    
    func pathActionChoices() -> [PathAction] {
        return pathOptions
    }
}

