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
              ShopVCDelegate, ShopVCDataSource {
    
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
    
    var player1Name: String!
    var player2Name: String!
    
    private var shimmerView: FBShimmeringView!
    private var endTurnTimer: Timer?
    private var session: Session!
    private var boardView: BoardView!
    private var handView: HandView!
    private var burnView: UIView?
    private var longPressedPawn: PawnView?
    private var highlightDict: [Coordinate:UIColor] = [:]
    private var state: State = .Normal
    private var playOptionDict: [Coordinate:[PlayOption]] = [:]
    private var canShop: Bool = true
    
    // MARK: Computed properties
    private var canResurrect: Bool {
        return hand.containsType(ResurrectCard.self) && board.hasOpenHomeSpot(player: player) && player.deadPawns > 0
    }
    private var canBurn: Bool {
        return hand.containsType(BurnCard.self)
    }
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
    private var totalGems: Int {
        var totalGems: Int = 0
        
        for card in hand {
            if type(of: card) == GemCard.self {
                totalGems += (card.cost / 3) + 1
            }
        }
        return totalGems
    }
    private var printPlayOptions: String {
        var result = "Play Option Dictionary:\n"
        for (coordinate, playOptions) in playOptionDict {
            result += "Target: \(coordinate.description)\nPlay Options:\n"
            for playOption in playOptions {
                result += "\(playOption.description)"
            }
        }
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let player1 = Player(number: 0, name: player1Name)
        let player2 = Player(number: 1, name: player2Name)
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
        
        // TODO: From viewDidAppear. Delete later?
        player.hand.newHand(for: player)
        opponent.hand.newHand(for: opponent)
        startNewTurn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        player.hand.newHand(for: player)
//        opponent.hand.newHand(for: opponent)
//        startNewTurn()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desination = segue.destination as? ShopVC {
            desination.dataSource = self
            desination.delegate = self
        }
    }
    
    private func startNewTurn() {
        endTurnTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(enableEndTurn), userInfo: nil, repeats: false)
        playerLabel.text = "\(player.name.uppercased())"
        handView.animateDeal(from: view.frame.center) { (completed) in
            self.animateDealCallback(dealComplete: completed)
        }
        canShop = true
        updateActionButtons()
    }
    
    private func endTurn() {
        hand.newHand(for: player)
        player = session.nextPlayerTurn()
        board.rotateBoard()
        toggleTurnLabel()
        refresh()
        startNewTurn()
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
    
    // MARK: - IBActions
    @IBAction func endTurnPressed(_ sender: UIButton) {
        endTurn()
    }
    
    @IBAction func burnPressed(_ sender: UIButton) {
        setNextState(.Burn)
        burnView = UIView(frame: view.frame)
        burnView!.backgroundColor = Colors.offWhite
        burnView!.alpha = 0.95
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissBurnView))
        burnView?.addGestureRecognizer(tapRecognizer)
        
        let width: CGFloat = view.bounds.width * 2/3
        let height: CGFloat = 50
        let xPos: CGFloat = view.bounds.width / 6
        let yPos: CGFloat = handView.frame.minY - height
        let infoFrame = CGRect(x: xPos, y: yPos, width: width, height: height)
        let infoLabel = UILabel(frame: infoFrame)
        infoLabel.text = "Tap the card you wish to remove from your deck."
        infoLabel.textColor = Colors.font
        infoLabel.font = UIFont(name: "Montserrat-Regular", size: 20)
        infoLabel.numberOfLines = 2
        infoLabel.textAlignment = .center
        burnView?.addSubview(infoLabel)
        
        view.addSubview(burnView!)
        view.bringSubview(toFront: handView)
        
        enableEndTurn()
    }
    
    @objc private func dismissBurnView() {
        setNextState(.Normal)
        burnView?.removeFromSuperview()
    }
    
    @IBAction func shopPressed(_ sender: UIButton) {
//        let shopVC = ShopVC()
//        
        enableEndTurn()
//        
//        shopVC.dataSource = self
//        shopVC.delegate = self
//        
//        addChildViewController(shopVC)
//        view.addSubview(shopVC.view)
//        
//        shopVC.didMove(toParentViewController: self)
    }
    
    @IBAction func resurrectPressed(_ sender: UIButton) {
        setNextState(.Resurrect)
        
        for column in 0..<board.count {
            let coordinate = try! Coordinate(column: column, row: board.count - 1)
            let space = board.getSpace(coordinate)
            if space.isHome && !space.isOccupied {
                highlightDict[coordinate] = Colors.yellow
            }
        }
        boardView.updateBoard()
        enableEndTurn()
    }
    
    private func animateDealCallback(dealComplete: Bool) {
        if dealComplete {
            updateActionButtons()
        }
    }

    @objc private func enableEndTurn() {
        if endTurnButton.isHidden {
            endTurnTimer?.invalidate()
            endTurnTimer = nil
            endTurnButton.isHidden = false
            endTurnLabel.isHidden = true
            shimmerView.isHidden = true
            endTurnButton.backgroundColor = player.number == 0 ? Colors.player1Light : Colors.player2Light
        }
    }
    
    private func toggleTurnLabel() {
        endTurnLabel.isHidden = !endTurnLabel.isHidden
        endTurnButton.isHidden = !endTurnLabel.isHidden
        shimmerView.isHidden = !shimmerView.isHidden
    }
    
    // MARK: - BoardView delegate and data source functions
    func highlightForSpace(at coordinate: Coordinate) -> UIColor {
        return highlightDict[coordinate] ?? Colors.grey
    }
    
    func spaceTapped(at coordinate: Coordinate) {
        let space = board.getSpace(coordinate)
        
        if state == .Resurrect && space.isHome && !space.isOccupied {
            space.pawn = Pawn(owner: player)
            player.deadPawns -= 1
            hand.discardCard(of: ResurrectCard.self, for: player)
            highlightDict = [:]
            handView.refresh()
            refresh()
            updateActionButtons()
        }
        
        setNextState(.Normal)
    }
    
    func pawnLongPressBegan(at coordinate: Coordinate, at location: CGPoint) {
        let space = board.getSpace(coordinate)
        
        // If user long presses one of their pawns
        if space.isOccupied && space.pawn!.owner == player && !space.pawn!.hasReachedGoal {
            setNextState(.Normal)
            
            generatePlayOptions(at: coordinate)
            print(printPlayOptions)
            
            highlightOptions(playOptionDict)
            boardView.updateHighlights()
            
            space.pawn = nil
            
            let imageWidth = view.bounds.size.width * (44/320) * 1.25
            let imageHeight = view.bounds.size.height * (48/568) * 1.25
            let xPos = location.x - imageWidth / 2
            let yPos = location.y - imageHeight * 1.5
            let longPressedPawnFrame = CGRect(x: xPos, y: yPos, width: imageWidth, height: imageHeight)
            longPressedPawn = PawnView(frame: longPressedPawnFrame, owner: player)
            
            // Add shadow
            longPressedPawn!.layer.shadowColor = Colors.font.cgColor
            longPressedPawn!.layer.shadowOpacity = 0.7
            longPressedPawn!.layer.shadowOffset = CGSize(width: 0, height: imageHeight)
            longPressedPawn!.layer.shadowRadius = 1.5
            
            view.addSubview(longPressedPawn!)
        }
    }
    
    func pawnLongPressChanged(at location: CGPoint) {
        let imageHeight = view.bounds.size.height * (48/568) * 1.25
        let xPos = location.x
        let yPos = location.y - imageHeight
        longPressedPawn?.center = CGPoint(x: xPos, y: yPos)
    }
    
    func pawnLongPressEnded(at target: Coordinate, from source: Coordinate) {
        let playOptions = playOptionDict[target] ?? []
        let finishingTouches: () -> () = {
            self.playOptionDict = [:]
            self.updateActionButtons()
            self.enableEndTurn()
            if self.playerHasWon() {
                print("\(self.player.name) has won!!")
            }
        }
        let callback: (PlayOption) -> () = { chosenOption in
            self.attemptPawnPlacement(using: chosenOption, from: source, to: target)
            finishingTouches()
        }
        
        if playOptions.isEmpty {
            placePawn(at: source)
            finishingTouches()
        } else if playOptions.count == 1 {
            callback(playOptions[0])
        } else {
            // Prompt user for which path to use
            print("Prompting user...")
            promptUser(for: playOptions, callback: callback)
        }
        
    }
    
    private func playerHasWon() -> Bool {
        var pawnsReachedGoal: Int = 0
        for column in 0..<board.count {
            let coordinate = try! Coordinate(column: column, row: 0)
            let space = board.getSpace(coordinate)
            if let pawn = space.pawn {
                pawnsReachedGoal += pawn.hasReachedGoal ? 1 : 0
            }
        }
        return pawnsReachedGoal == Constants.numberOfSpaces
    }
    
    // MARK: Helper functions
    private func generatePlayOptions(at source: Coordinate) {
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
                let paths = movementCard.getPaths(source)
                for path in paths {
                    var playOptions: [PlayOption] = []
                    
                    let action = getPathAction(for: path)
                    switch action {
                    case .Move:
                        let moveOption = PlayOption(path: path, action: action, requiredCards: [movementCardType])
                        playOptions = [moveOption]
                        
                    case .Attack:
                        if hasAttackCard {
                            let attackOption = PlayOption(path: path, action: action, requiredCards: [movementCardType,AttackCard.self])
                            playOptions = [attackOption]
                        }
                    case .Jump:
                        if hasJumpCard {
                            let jumpOption = PlayOption(path: path, action: action, requiredCards: [movementCardType,JumpCard.self])
                            playOptions = [jumpOption]
                        }
                    case .JumpAndAttack:
                        if hasAttackCard && hasJumpCard {
                            let jumpAttackOption = PlayOption(path: path, action: action, requiredCards: [movementCardType,AttackCard.self,JumpCard.self])
                            playOptions = [jumpAttackOption]
                        }
                    case .JumpOrAttack:
                        if hasAttackCard {
                            let attackOption = PlayOption(path: path, action: .Attack, requiredCards: [movementCardType,AttackCard.self])
                            playOptions.append(attackOption)
                        }
                        if hasJumpCard {
                            let jumpOption = PlayOption(path: path, action: .Jump, requiredCards: [movementCardType,JumpCard.self])
                            playOptions.append(jumpOption)
                        }
                    case .None:
                        break
                    }
                    
                    for playOption in playOptions {
                        let target = playOption.path.end
                        if playOptionDict[target] == nil {
                            playOptionDict[target] = [playOption]
                        } else {
                            playOptionDict[target]?.append(playOption)
                        }
                    }
                }
            }
        }
    }
    
    
    private func promptUser(for playOptions: [PlayOption], callback: @escaping (PlayOption) -> Void) {
        var chosenOption: PlayOption!
        
        // FIXME: Remove temp
        let index = Int(arc4random_uniform(UInt32(playOptions.count)))
        chosenOption = playOptions[index]
        print("Chosen Option: \(index)")
        callback(chosenOption)
        
        // TODO: Prompt user
//        let playOptionVC = PlayOptionVC(playOptions: playOptions)
//        present(playOptionVC, animated: true) { 
//            code
//        }
//        
//        callback(chosenOption)
    }
    
    private func attemptPawnPlacement(using playOption: PlayOption, from source: Coordinate, to target: Coordinate) {
        let path = playOption.path
        var usedCardTypes: [Card.Type] = [path.requiredMovementCardType()]
        
        switch playOption.action {
        case .JumpAndAttack:
            if opponent.hand.containsType(DefendCard.self) {
                showDefendAnimation()
                opponent.hand.discardCard(of: DefendCard.self, for: opponent)
                placePawn(at: source)
            } else {
                removeOpponentPawns(along: path)
                placePawn(at: target)
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
                removeOpponentPawns(along: path)
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
    
    private func placePawn(at coordinate: Coordinate) {
        
        longPressedPawn!.removeFromSuperview()

        let space = board.getSpace(coordinate)

        space.pawn = Pawn(owner: player)

        if space.isGoal {
            space.pawn!.hasReachedGoal = true
        }
        
        print("\(board.printPawns)")
        
        highlightDict = [:]
        
        refresh()
        handView.refresh()
    }
    
    private func removeOpponentPawns(along path: Path) {
        for coordinate in path {
            let space = board.getSpace(coordinate)
            if space.isOccupied && space.pawn!.owner == opponent {
                opponent.deadPawns += 1
                space.pawn = nil
            }
        }
    }
    
    private func removeUsedCards(in usedCardTypes: [Card.Type]) {
        for tileType in usedCardTypes {
            hand.discardCard(of: tileType, for: player)
        }
        handView.refresh()
        refresh()
        if hand.isEmpty {
            endTurn()
        }
    }
    
    private func getPathAction(for path: Path) -> PathAction {
        var enemies: Int = 0
        var allies: Int = 0
        var endOccupiedByEnemy: Bool = false
        var endOccupiedByAlly: Bool = false
        
        for coordinate in path {
            let space = board.getSpace(coordinate)
            if coordinate != path.beginning {
                if let pawn = space.pawn {
                    if pawn.owner == player || pawn.hasReachedGoal {
                        allies += 1
                    } else {
                        enemies += 1
                    }
                }
            }
            if coordinate == path.end && space.isOccupied {
                if space.pawn!.owner == player {
                    endOccupiedByAlly = true
                } else {
                    endOccupiedByEnemy = true
                }
            }
        }
        
        let endUnoccupied: Bool = !(endOccupiedByEnemy || endOccupiedByAlly)
        
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
            let space = board.getSpace(coordinate)
            if space.isOccupied {
                if space.pawn!.owner !== player {
                    return coordinate
                }
            }
        }
        return nil
    }
    
    private func highlightOptions(_ playOptionDict: [Coordinate:[PlayOption]]) {
        // TODO: Use PlayOptions to make highlights
        
        for (_, playOptions) in playOptionDict {
            for playOption in playOptions {
                for coordinate in playOption.path {
                    let path = playOption.path
                    if coordinate == path.end {
                        highlightDict[coordinate] = Colors.blueShadow
                    } else if highlightDict[coordinate] != Colors.blueShadow && coordinate != path.beginning {
                        highlightDict[coordinate] = Colors.blue
                    } else if coordinate == path.beginning {
                        highlightDict[coordinate] = Colors.grey
                    }
                }
            }
        }
    }
    
    private func highlightSpaces(for paths: [Path]) {
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
    
    private func removeGems() {
        hand.discardAllCards(type: GemCard.self, for: player)
        if hand.isEmpty {
            endTurn()
        }
    }

    // MARK: - HandView delegate and data source functions
    func numberOfCards() -> Int {
        return hand.count
    }
    
    func cardTapped(at index: Int) {
        enableEndTurn()
        
        if state == .Burn {
            hand.burnCard(at: index)
            hand.discardCard(of: BurnCard.self, for: player)
            handView.refresh()
            updateActionButtons()
            burnView?.removeFromSuperview()
            setNextState(.Normal)
            if hand.isEmpty {
                endTurn()
            }
        } else {
            // TODO: Info card
        }
        
    }
    
    private func setNextState(_ nextState: State) {
        state = nextState
        switch state {
        case .Normal:
            break
        case .Burn:
            break
        case .Shop:
            break
        case .Resurrect:
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
            let space = board.getSpace(coordinate)
            if space.isHome && !space.isOccupied {
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
}

