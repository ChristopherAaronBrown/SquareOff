//
//  MainViewController.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class GameSpaceViewController: UIViewController, BoardViewDataSource, BoardViewDelegate, HandViewDataSource, HandViewDelegate {
    
    private let gameSession: GameSession
    var boardView: BoardView?
    var handView: HandView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Add board to view
        let boardSize: CGFloat = UIScreen.mainScreen().bounds.width - 10
        let boardXPos: CGFloat = 5 + (boardSize % 8) / 2
        let boardYPos: CGFloat = UIApplication.sharedApplication().statusBarFrame.height + boardXPos
        
        boardView = BoardView(frame: CGRectMake(boardXPos, boardYPos, boardSize, boardSize))
        
        boardView!.dataSource = self
        boardView!.delegate = self
        
        self.view.addSubview(boardView!)
        
        boardView?.updateBoard()
        
        // Add hand to view
        let handWidth: CGFloat = UIScreen.mainScreen().bounds.width
        let handHeight: CGFloat = (handWidth - 60) / 5
        let handXPos: CGFloat = 0
        let handYPos: CGFloat = boardYPos + boardSize + 50
        handView = HandView(frame: CGRectMake(handXPos, handYPos, handWidth, handHeight))
        
        handView!.dataSource = self
        handView!.delegate = self
        
        self.view.addSubview(handView!)
    }
    
    // MARK: - Initializers
    init(gameSession: GameSession) {
        self.gameSession = gameSession
        gameSession.player1.playerHand.newHand(gameSession.player1)
        gameSession.player2.playerHand.newHand(gameSession.player2)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - BoardViewDataSource
    func imageForSpace(coordinate: BoardCoordinate) -> UIImage? {
        let modelCoordinate = gameSession.currentPlayer == 0 ? coordinate : coordinate.inverse()
        
        return gameSession.board.getBoardSpace(modelCoordinate).playerPawn?.pawnImage
    }
    
    func backgroundColorForSpace(coordinate: BoardCoordinate) -> UIColor {
        let modelCoordinate = gameSession.currentPlayer == 0 ? coordinate : coordinate.inverse()
        
        if gameSession.board.getBoardSpace(modelCoordinate).isHome(gameSession.player1) {
            return UIColor.darkGrayColor()
        } else if gameSession.board.getBoardSpace(modelCoordinate).isHome(gameSession.player2) {
            return UIColor.lightGrayColor()
        } else {
            return UIColor.clearColor()
        }
    }
    
    // MARK: BoardViewDelegate
    func boardSpaceWasTapped(coordinate: BoardCoordinate) {
        if gameSession.board.getBoardSpace(coordinate).isOccupied() {
            gameSession.nextTurn()
            boardView?.updateBoard()
            handView!.setNeedsLayout()
        }
    }
    
    // MARK: - HandViewDataSource
    func numberOfTiles() -> UInt {
        let player = gameSession.currentPlayer == 0 ? gameSession.player1 : gameSession.player2
        return UInt(player.playerHand.count() ?? 0)
    }
    
    func imageForTile(index: UInt) -> UIImage? {
        let player = gameSession.currentPlayer == 0 ? gameSession.player1 : gameSession.player2
        let imageName = player.playerHand.tiles[Int(index)].imageName
        return UIImage(named: imageName)
    }
    
    // MARK: HandViewDelegate
    func handViewSlotWasTapped(index: UInt) {
        let player = gameSession.currentPlayer == 0 ? gameSession.player1 : gameSession.player2
        player.playerHand.newHand(player)
        handView!.setNeedsLayout()
    }
}

