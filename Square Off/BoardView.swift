//
//  BoardView.swift
//  Square Off
//
//  Created by Chris Brown on 8/21/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

protocol BoardViewDataSource {
    func imageForSpace(coordinate: BoardCoordinate) -> UIImage?
    func backgroundColorForSpace(coordinate: BoardCoordinate) -> UIColor
}

protocol BoardViewDelegate {
    func boardSpaceWasTapped(coordinate: BoardCoordinate)
}

class BoardView: UIView {
    
    var dataSource: BoardViewDataSource?
    var delegate: BoardViewDelegate?
    private var imageDict: [BoardCoordinate : UIImageView]
    
    override init(frame: CGRect) {
        imageDict = [:]
        
        super.init(frame: frame)
    
        let numberOfBoardSpaces = 8
        let boardSize: CGFloat = self.bounds.width
        let boardSpaceSize: CGFloat = floor(boardSize / CGFloat(numberOfBoardSpaces))
        let boardBorder: UIView = UIView(frame: CGRectMake(0, 0, boardSpaceSize * 8, boardSpaceSize * 8))
        
        // Add outside frame
        boardBorder.layer.borderWidth = 1
        boardBorder.layer.borderColor = UIColor.blackColor().CGColor
        self.addSubview(boardBorder)
        
        for column in 0...7 {
            for row in 0...7 {
                let coordinate = try! BoardCoordinate(column: column, row: row)
                let tag: Int = column + (row * 8)
                let xPos = boardSpaceSize * CGFloat(column)
                let yPos = boardSpaceSize * CGFloat(row)
                let boardSpaceImageView = UIImageView(frame: CGRectMake(xPos, yPos, boardSpaceSize, boardSpaceSize))
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BoardView.boardSpaceTapped))
                
                boardSpaceImageView.tag = tag
                boardSpaceImageView.layer.borderWidth = 0.5
                boardSpaceImageView.layer.borderColor = UIColor.blackColor().CGColor
                boardSpaceImageView.userInteractionEnabled = true
                boardSpaceImageView.addGestureRecognizer(tapRecognizer)
                imageDict[coordinate] = boardSpaceImageView
                
                self.addSubview(boardSpaceImageView)                
            }
        }
    }
    
    func updateBoard() {
        for (coordinate, imageView) in imageDict {
            imageView.image = dataSource?.imageForSpace(coordinate)
            imageView.backgroundColor = dataSource?.backgroundColorForSpace(coordinate)
        }
    }
    
    func boardSpaceTapped(sender: UITapGestureRecognizer) {
        if let boardSpaceImageView = sender.view {
            let tag = boardSpaceImageView.tag
            let coordinate = try! BoardCoordinate(column: tag % 8, row: tag / 8)
            self.delegate?.boardSpaceWasTapped(coordinate)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}