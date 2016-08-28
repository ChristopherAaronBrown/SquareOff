//
//  MainViewController.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class GameSpaceViewController: UIViewController, HandViewDataSource, HandViewDelegate {
    
    private var handView: HandView?
    private var boardView: BoardView?
    var gameBoard: GameBoard?
    var player: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        gameBoard = GameBoard()
        player = Player(playerNum: 0, playerName: "Chris")
        player?.playerHand.newHand(player!)
        
//        // Add board to view
//        let boardDimension: CGFloat = UIScreen.mainScreen().bounds.width - 10
//        let boardXPos: CGFloat = 5 + (boardDimension % 8) / 2
//        let boardYPos: CGFloat = UIApplication.sharedApplication().statusBarFrame.height + boardXPos
//        boardView = BoardView(frame: CGRectMake(boardXPos, boardYPos, boardDimension, boardDimension))
        
        
        
//        self.view.addSubview(boardView!)
        
        // Add player hand to view
        let handWidth: CGFloat = UIScreen.mainScreen().bounds.width
        let handHeight: CGFloat = (handWidth - 60) / 5
        let handXPos: CGFloat = 0
//        let handYPos: CGFloat = boardYPos + boardDimension + 50
        let handYPos: CGFloat = 500
        handView = HandView(frame: CGRectMake(handXPos, handYPos, handWidth, handHeight))
        
        handView!.dataSource = self
        handView!.delegate = self
        
        self.view.addSubview(handView!)
        
    }
    
    // MARK: HandViewDataSource
    func numberOfTiles() -> UInt {
        return UInt(player?.playerHand.count() ?? 0)
    }
    
    func imageForTile(index: UInt) -> UIImage? {
        guard let imageName = self.player?.playerHand.tiles[Int(index)].imageName else {
            return nil
        }
        return UIImage(named: imageName)
    }
    
    // MARK: HandViewDelegate
    func handViewSlotWasTapped(index: UInt) {
        print("Tapped at index: \(index)")
        if let player = self.player {
            player.playerHand.newHand(player)
            handView!.setNeedsLayout()
        }
    }
    
    func currentBoard() -> GameBoard {
        return self.gameBoard!
    }
}

