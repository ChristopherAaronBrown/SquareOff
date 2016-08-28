//
//  BoardView.swift
//  Square Off
//
//  Created by Chris Brown on 8/21/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

protocol BoardViewDataSource {
    func pawnPositions() -> GameBoard
    func currentPlayer() -> Int
}

protocol BoardViewDelegate {
    
}

class BoardView: UIView {
    
    var dataSource: BoardViewDataSource?
    var delegate: BoardViewDelegate?
    
    init(frame: CGRect, currentPlayer: Int) {
        super.init(frame: frame)
        
        let board = dataSource!.pawnPositions()
        
        let boardSpaceDimension: CGFloat = floor(self.bounds.width / 8)

        // TODO: Flip board based on current player
        for column in 0...7 {
            for row in 0...7 {
                let coordinate = try! BoardCoordinate(column: column, row: row)

                let xPos = boardSpaceDimension * CGFloat(column)
                let yPos = boardSpaceDimension * CGFloat(row)
                let boardSpaceImageView = UIImageView(frame: CGRectMake(xPos, yPos, boardSpaceDimension, boardSpaceDimension))
                
                // Add home space colors
                switch row {
                case 0:
                    boardSpaceImageView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(1)
                case 7:
                    boardSpaceImageView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(1)
                default:
                    boardSpaceImageView.backgroundColor = UIColor.clearColor()
                }
                
                if board.getBoardSpace(coordinate).isOccupied() {
                    boardSpaceImageView.image = board.getBoardSpace(coordinate).occupyingPawn().pawnImage
                }
                
                boardSpaceImageView.layer.borderWidth = 1
                boardSpaceImageView.layer.borderColor = UIColor.blackColor().CGColor
                
                self.addSubview(boardSpaceImageView)
            }
        }
    }
    
    func updateBoard() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}