//
//  BoardViewController.swift
//  Square Off
//
//  Created by Chris Brown on 8/27/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController, BoardViewDataSource, BoardViewDelegate {
    
    private var gameSession: GameSession
    var boardView: BoardView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBoard(0)
        boardView!.dataSource = self
        boardView!.delegate = self
    }
    
    func drawBoard(currentPlayer: Int) {
        let boardDimension: CGFloat = UIScreen.mainScreen().bounds.width - 10
        let boardXPos: CGFloat = 5 + (boardDimension % 8) / 2
        let boardYPos: CGFloat = UIApplication.sharedApplication().statusBarFrame.height + boardXPos
        
        boardView? = BoardView(frame: CGRectMake(boardXPos, boardYPos, boardDimension, boardDimension),currentPlayer: gameSession.currentPlayer)
    }
    
    // MARK: - Initializers
    init(gameSession: GameSession) {
        self.gameSession = gameSession
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - BoardViewDataSource
    func pawnPositions() -> GameBoard {
        return gameSession.board
    }
    
    func currentPlayer() -> Int {
        return gameSession.currentPlayer
    }
}