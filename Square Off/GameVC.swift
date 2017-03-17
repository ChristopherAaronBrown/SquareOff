//
//  GameVC.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit
import Shimmer

class GameVC: UIViewController,
              BoardViewDelegate, BoardViewDataSource,
              HandViewDelegate, HandViewDataSource,
              ShopVCDelegate, ShopVCDataSource,
              PathOptionVCDelegate, PathOptionVCDataSource {
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var endTurnLabel: UILabel!
    @IBOutlet weak var endTurnButton: UIButton!
    @IBOutlet weak var burnButton: UIButton!
    @IBOutlet weak var burnImageView: UIImageView!
    @IBOutlet weak var burnLabel: UILabel!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var resurrectButton: UIButton!
    @IBOutlet weak var resurrectImageView: UIImageView!
    @IBOutlet weak var resurrectLabel: UILabel!
    
    private var shimmerView: FBShimmeringView!
    private var endTurnTimer: Timer?
    private var session: Session!
    private var boardView: BoardView!
    private var handView: HandView!
    private var player: Player {
        get {
            return session.currentPlayer
        }
        set {
            session.currentPlayer = newValue
            updateActionButtons()
        }
    }
    private var opponent: Player {
        return player.number == 0 ? session.player2 : session.player1
    }
    private var board: Board {
        return session.board
    }
    private var hand: Hand {
        return player.hand
    }
    private var deck: Deck {
        return player.deck
    }
    private var discard: Discard {
        return player.discard
    }
    private var canResurrect: Bool {
        return hand.containsType(ResurrectCard.self) && board.hasOpenHomeSpot(player: player) && player.deadPawns > 0
    }
    private var canBurn: Bool {
        return hand.containsType(BurnCard.self)
    }
    private var canShop: Bool = true
    private var totalGems: Int {
        var totalGems: Int = 0
        
        for card in hand {
            if type(of: card) == GemCard.self {
                totalGems += (card.cost / 3) + 1
            }
        }
        
        return totalGems
    }
    private var longPressedPawn: PawnView?
    private var requiredCardTypes: [Coordinate:[Card.Type]] = [:]
    private var eligiblePaths: [Path] = []
    private var highlightDict: [Coordinate:UIColor] = [:]
    private var pathOptions: [PathAction] = []
    private var pathActionChosen: PathAction = .None
    private var movementCardOption: MovementCard.Type!
    private var state: State = .Normal
    private var playOptions: [Coordinate:[PlayOption]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let player1 = Player(number: 0, name: "Chris")
        let player2 = Player(number: 1, name: "Greg")
        let board = Board(player1: player1, player2: player2)
        let session = Session(player1: player1, player2: player2, board: board)
        
        self.session = session
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(enableEndTurn))
        
        endTurnButton.layer.cornerRadius = 12
        
        shimmerView = FBShimmeringView(frame: endTurnLabel.frame)
        shimmerView.contentView = endTurnLabel
        shimmerView.isShimmering = true
        shimmerView.addGestureRecognizer(tapRecognizer)
        
        view.addSubview(shimmerView)
        
        // Add board to view
        let boardWidth: CGFloat = view.bounds.width - 16
        let boardHeight: CGFloat = boardWidth
        let boardXPos: CGFloat = 8
        let boardYPos: CGFloat = headerView.frame.maxY
        let boardFrame = CGRect(x: boardXPos, y: boardYPos, width: boardWidth, height: boardHeight)
        
        boardView = BoardView(frame: boardFrame, board: board)
        
        view.addSubview(boardView)
        
        boardView.delegate = self
        boardView.dataSource = self
        
        // Add hand to view
        let handWidth: CGFloat = view.bounds.width
        let handHeight: CGFloat = view.bounds.height * (110/568)
        let handXPos: CGFloat = 0
        let handYPos: CGFloat = view.bounds.height * (468/568)

        let handFrame = CGRect(x: handXPos, y: handYPos, width: handWidth, height: handHeight)
        
        handView = HandView(frame: handFrame)
        handView.clipsToBounds = false
        view.addSubview(handView)
        
        handView.delegate = self
        handView.dataSource = self
        
        refresh()
        updateActionButtons()
        handView.refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        opponent.hand.newHand(for: opponent)
        startNewTurn()
    }
    
    private func startNewTurn() {
        endTurnTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(enableEndTurn), userInfo: nil, repeats: false)
        hand.newHand(for: player)
        handView.animateDeal(from: view.frame.center) { (completed) in
            self.animateDealCallback(dealComplete: completed)
        }
        canShop = true
        updateActionButtons()
    }
    
    private func refresh() {
        setNextState(.Normal)
        boardView.updateBoard()
        handView.refresh()
    }
    
    private func updateActionButtons() {
        let disabledAlpha: CGFloat = 0.4
        
        // Burn
        burnButton.isEnabled = canBurn
        burnImageView.alpha = canBurn ? 1 : disabledAlpha
        burnLabel.alpha = canBurn ? 1 : disabledAlpha
        
        // Shop
        shopButton.isEnabled = canShop
        shopImageView.alpha = canShop ? 1 : disabledAlpha
        shopLabel.alpha = canShop ? 1 : disabledAlpha
        shopLabel.text = canShop ? "SHOP (\(totalGems))" : "SHOP"
        
        // Resurrect
        resurrectButton.isEnabled = canResurrect
        resurrectImageView.alpha = canResurrect ? 1 : disabledAlpha
        resurrectLabel.alpha = canResurrect ? 1 : disabledAlpha
        resurrectLabel.text = player.deadPawns > 0 ? "SPAWN (\(player.deadPawns))" : "SPAWN"
    }
    
    @IBAction func endTurnPressed(_ sender: UIButton) {
        hand.newHand(for: player)
        player = session.nextPlayerTurn()
        board.rotateBoard()
        toggleTurnLabel()
        refresh()
        startNewTurn()
    }
    
    @IBAction func burnPressed(_ sender: UIButton) {
        enableEndTurn()
    }
    
    @IBAction func shopPressed(_ sender: UIButton) {
        let shopVC = ShopVC()
        
        enableEndTurn()
        
        shopVC.dataSource = self
        shopVC.delegate = self
        
        addChildViewController(shopVC)
        view.addSubview(shopVC.view)
        
        shopVC.didMove(toParentViewController: self)
    }
    
    @IBAction func resurrectPressed(_ sender: UIButton) {
        enableEndTurn()
    }
    
    func animateDealCallback(dealComplete: Bool) {
        if dealComplete {
            updateActionButtons()
        }
    }

    func enableEndTurn() {
        if endTurnButton.isHidden {
            endTurnTimer?.invalidate()
            endTurnTimer = nil
            endTurnButton.isHidden = false
            endTurnLabel.isHidden = true
            shimmerView.isHidden = true
            endTurnButton.backgroundColor = player.number == 0 ? Colors.player1Light : Colors.player2Light
        }
    }
    
    func toggleTurnLabel() {
        endTurnLabel.isHidden = !endTurnLabel.isHidden
        endTurnButton.isHidden = !endTurnLabel.isHidden
        shimmerView.isHidden = !shimmerView.isHidden
    }
    
    // MARK: - BoardView delegate and data source functions
    func pawnViewForSpace(at coordinate: Coordinate) -> PawnView? {
        let modelCoordinate = player.number == 0 ? coordinate : coordinate.inverse
        
        if let pawn = board.getBoardSpace(modelCoordinate).pawn {
            let frame = CGRect(x: 0, y: 0, width: 44, height: 48)
            return PawnView(frame: frame, owner: pawn.owner)
        }
        
        // FIXME: Should not return nil
        return nil
    }
    
    func highlightForSpace(at coordinate: Coordinate) -> UIColor {
        let modelCoordinate = player.number == 0 ? coordinate : coordinate.inverse
        
        if let highlight = highlightDict[modelCoordinate] {
            return highlight
        }
        
        return Colors.grey
    }
    
    func currentBoard() -> Board {
        return board
    }
    
    func boardSpaceTapped(at coordinate: Coordinate) {
        let modelCoordinate = player.number == 0 ? coordinate : coordinate.inverse
        let space = board.getBoardSpace(modelCoordinate)
        
        if state == .ResurrectCardTapped && space.isHome(for: player) && !space.isOccupied() {
            space.pawn = Pawn(owner: player)
            player.deadPawns -= 1
            hand.discardCard(of: ResurrectCard.self, for: player)
            highlightDict = [:]
            handView.refresh()
            refresh()
            updateActionButtons()
        }
    }
    
    func pawnLongPressBegan(at coordinate: Coordinate, with touchLocation: CGPoint) {
        let modelCoordinate = player.number == 0 ? coordinate : coordinate.inverse
        let space = board.getBoardSpace(modelCoordinate)
        
        // If user long presses one of their pawns
        if space.isOccupied() && space.pawn!.owner == player && !space.pawn!.hasReachedGoal {
            setNextState(.Normal)
            
            // Generate play options
            generatePlayOptions(at: modelCoordinate)
            
            // Determine all eligible paths from the origin board space
            eligiblePaths = findEligiblePaths(at: modelCoordinate)
            
            highlightSpaces(for: eligiblePaths, at: modelCoordinate)
            
            space.pawn = nil
            if longPressedPawn == nil {
                let imageWidth = view.bounds.size.width * (44/320) * 1.25
                let imageHeight = view.bounds.size.height * (48/568) * 1.25
                let xPos = touchLocation.x - imageWidth / 2
                let yPos = touchLocation.y - imageHeight * 1.5
                let longPressedPawnFrame = CGRect(x: xPos, y: yPos, width: imageWidth, height: imageHeight)
                longPressedPawn = PawnView(frame: longPressedPawnFrame, owner: player)
                
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
    
    func pawnLongPressEnded(at targetBoardCoordinate: Coordinate, from sourceBoardCoordinate: Coordinate) {
        
        let target = player.number == 0 ? targetBoardCoordinate : targetBoardCoordinate.inverse
        let source = player.number == 0 ? sourceBoardCoordinate : sourceBoardCoordinate.inverse
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
        
        enableEndTurn()
    }
    
    // MARK: Helper functions
    private func generatePlayOptions(at modelCoordinate: Coordinate) {
        var hasAttackCard = false
        var hasJumpCard = false
        
        for card in hand {
            if type(of: card) == AttackCard.self {
                hasAttackCard = true
                continue
            }
            if type(of: card) == JumpCard.self {
                hasJumpCard = true
            }
        }
        
        for card in hand {
            if let movementCard = card as? MovementCard {
                let movementCardType = type(of: movementCard) as! Card.Type
                let paths = movementCard.getPaths(modelCoordinate, player: player)
                for path in paths {
                    var playOptions: [PlayOption] = []
                    
                    let action = getPathAction(for: path)
                    switch action {
                    case .Move:
                        playOptions = [PlayOption(path: path, actions: [action : [movementCardType]])]
                        
                    case .Attack:
                        if hasAttackCard {
                            playOptions = [PlayOption(path: path, actions: [action : [movementCardType,AttackCard.self]])]
                        }
                    case .Jump:
                        if hasJumpCard {
                            playOptions = [PlayOption(path: path, actions: [action : [movementCardType,JumpCard.self]])]
                        }
                    case .JumpAndAttack:
                        if hasAttackCard && hasJumpCard {
                            playOptions = [PlayOption(path: path, actions: [action : [movementCardType,AttackCard.self,JumpCard.self]])]
                        }
                    case .JumpOrAttack:
                        if hasAttackCard && hasJumpCard {
                            playOptions = [PlayOption(path: path, actions: [action : [movementCardType,AttackCard.self]])]
                            playOptions.append(PlayOption(path: path, actions: [action : [movementCardType,JumpCard.self]]))
                        }
                    default:
                        break
                    }
                    
                    if self.playOptions.isEmpty {
                        self.playOptions[modelCoordinate] = playOptions
                    } else {
                        for playOption in playOptions {
                            self.playOptions[modelCoordinate]?.append(playOption)
                        }
                    }
                }
            }
        }
    }
    
    
    private func promptUser(for paths: [Path], callback: (Path) -> Void) {
        var chosenPath: Path!
        
        chosenPath = paths[0]
//        for path in paths {
//            pathOptions.append(getPathAction(for: path))
//        }
//        
//        if pathOptions.contains(.Attack) || pathOptions.contains(.JumpAndAttack) {
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
//            // PathOptionVC will set pathActionChosen
//        } else {
//            pathActionChosen = .Move
//        }
//        
//        for path in paths {
//            if getPathAction(for: path) == pathActionChosen {
//                chosenPath = path
//                break
//            } else {
//                chosenPath = paths[0]
//            }
//        }
//        
//        pathActionChosen = .None
//
//        for i in 0..<paths.count {
//            print("#\(i):")
//            print("Path: \(paths[i])")
//            print("Action: \(getPathAction(for: paths[i]))")
//        }
        
        callback(chosenPath)
    }
    
    private func attemptPawnPlacement(along path: Path, from source: Coordinate, to target: Coordinate) {
        var usedCardTypes: [Card.Type] = [path.requiredMovementCardType()]
        
        switch getPathAction(for: path) {
        case .JumpAndAttack:
            if opponent.hand.containsType(DefendCard.self) {
                showDefendAnimation()
                opponent.hand.discardCard(of: DefendCard.self, for: opponent)
                placePawn(at: source)
            } else {
                placePawn(at: target)
                opponent.deadPawns += 1
            }
            usedCardTypes.append(JumpCard.self)
            usedCardTypes.append(AttackCard.self)
        case .Attack:
            if opponent.hand.containsType(DefendCard.self) {
                showDefendAnimation()
                opponent.hand.discardCard(of: DefendCard.self, for: opponent)
                let pawnCoordinate = attackCoordinate(along: path)!
                let closest = path.closest(coordinate: pawnCoordinate)
                placePawn(at: closest)
            } else {
                placePawn(at: target)
            }
            usedCardTypes.append(AttackCard.self)
        case .Jump:
            placePawn(at: target)
            usedCardTypes.append(JumpCard.self)
        case .Move:
            placePawn(at: target)
        default:
            break
        }
        removeUsedCards(in: usedCardTypes)
        playOptions = [:]
    }
    
    private func showDefendAnimation() {
        let backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = UIColor.white
        backgroundView.alpha = 0
        
        view.addSubview(backgroundView)
        
        let width: CGFloat = view.bounds.width * (175/320)
        let height: CGFloat = view.bounds.height * (245/568)
        let xPos: CGFloat = view.bounds.midX - width / 2
        let yPos: CGFloat = height * -1
        let frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        let defendCardView = CardView(frame: frame, player: opponent, icon: #imageLiteral(resourceName: "Defend-Info"))
        
        view.addSubview(defendCardView)
        
        let origin = frame.center
        let destination = CGPoint(x: frame.midX, y: height * 1.25)
        let duration: TimeInterval = 0.3
        let delay: TimeInterval = 0.75
        
        UIView.animate(withDuration: duration, animations: {
            defendCardView.center = destination
            backgroundView.alpha = 0.7
        }) { (complete) in
            
            if complete {
                UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
                    defendCardView.center = origin
                    backgroundView.alpha = 0
                }, completion: { (complete) in
                    defendCardView.removeFromSuperview()
                    backgroundView.removeFromSuperview()
                })
            }
        }
    }
    
    private func placePawn(at modelCoordinate: Coordinate) {
        if longPressedPawn != nil {
            longPressedPawn!.removeFromSuperview()
            longPressedPawn = nil

            let space = board.getBoardSpace(modelCoordinate)

            if space.isOccupied() && space.pawn!.owner !== player {
                space.pawn!.owner.deadPawns += 1
            }

            space.pawn = Pawn(owner: player)

            if space.isGoal(for: player) {
                space.pawn!.hasReachedGoal = true
            }

            requiredCardTypes = [:]
            highlightDict = [:]
            eligiblePaths = []
            
            refresh()
            handView.refresh()
        }
    }
    
    private func removeUsedCards(in usedCardTypes: [Card.Type]) {
        for tileType in usedCardTypes {
            hand.discardCard(of: tileType, for: player)
        }
        handView.refresh()
        refresh()
    }
    
    private func findEligiblePaths(at coordinate: Coordinate) -> [Path] {
        var eligiblePaths: [Path] = []
        
        /* For each movement card in hand:
         - Get paths and check if hand has tiles required to perform path.
         - If so, add to eligible paths and add required card to path end board space.
         - Then append all other card types needed to perform that path.
        */
        for card in hand {
            if let movementCard = card as? MovementCard {
                let paths = movementCard.getPaths(coordinate, player: player)
                for path in paths {
                    let (canPerform, tileTypes) = getPathAction(for: path).canPerform(with: hand)
                    if canPerform {
                        eligiblePaths.append(path)
                        if requiredCardTypes[path.end] == nil {
                            requiredCardTypes[path.end] = [type(of: card)]
                        }
                        requiredCardTypes[path.end]?.append(contentsOf: tileTypes)
                    }
                }
            }
        }
        return eligiblePaths
    }
    
    private func pathsEnding(at target: Coordinate) -> [Path] {
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
    
    private func attackCoordinate(along path: Path) -> Coordinate? {
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
    
    private func highlightSpaces(for paths: [Path], at modelCoordinate: Coordinate) {
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
                        if coordinate == attack && hand.containsType(AttackCard.self) {
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

    private func isEligibleTarget(_ target: Coordinate) -> Bool {
        for path in eligiblePaths {
            if path.end == target {
                return true
            }
        }
        
        return false
    }
    
    private func removeGems() {
        hand.discardAllCards(type: GemCard.self, for: player)
    }

    // MARK: - HandView delegate and data source functions
    func numberOfCards() -> Int {
        return hand.count
    }
    
    func handViewSlotWasTapped(at index: Int) {
        let tileType = type(of: hand.cards[index])
        
        enableEndTurn()
        
        if tileType == GemCard.self {
            let shopVC = ShopVC()
            
            shopVC.dataSource = self
            shopVC.delegate = self
            
            addChildViewController(shopVC)
            view.addSubview(shopVC.view)
            
            shopVC.didMove(toParentViewController: self)
            
        } else if tileType == ResurrectCard.self && player.deadPawns > 0 {
            setNextState(.ResurrectCardTapped)
            highlightResurrectSpaces()
        } else if tileType == BurnCard.self {
            // TODO: Implement Burn Card
        }
        
    }
    
    private func setNextState(_ nextState: State) {
        state = nextState
        switch state {
        case .Normal:
            break
        case .ResurrectCardTapped:
            break
        }
    }
    
    private func highlightResurrectSpaces() {
        for homeSpaceCoordinate in homeSpacesAvailable() {
            highlightDict[homeSpaceCoordinate] = Colors.yellow
        }
        boardView.updateBoard()
    }
    
    private func homeSpacesAvailable() -> [Coordinate] {
        var homeSpaceCoordinates: [Coordinate] = []
        let row = player.number == 0 ? Constants.numberOfSpaces - 1 : 0
        
        for col in 0..<Constants.numberOfSpaces {
            let coordinate = try! Coordinate(column: col, row: row)
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
    
    func purchased(card: Card) {
        canShop = false
        discard.add(card)
        removeGems()
        
        handView.refresh()
        refresh()
        updateActionButtons()
        
    }
    
    // MARK: - PathOptionVC delegate and data source functions
    func chosenAction(action: PathAction) {
        pathActionChosen = action
    }
    
    func pathActionChoices() -> [PathAction] {
        return pathOptions
    }
    
    func movementCard() -> MovementCard.Type {
        return movementCardOption
    }
}

