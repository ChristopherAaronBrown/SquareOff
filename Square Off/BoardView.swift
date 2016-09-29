//
//  BoardView.swift
//  Square Off
//
//  Created by Chris Brown on 8/21/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit
import CoreGraphics

protocol BoardViewDataSource {
    func imageForSpace(at coordinate: BoardCoordinate) -> UIImage?
    func backgroundColorForSpace(at coordinate: BoardCoordinate) -> UIColor
    func tintForPawn(at coordinate: BoardCoordinate) -> UIColor?
}

protocol BoardViewDelegate {
    func boardSpaceWasTapped(at coordinate: BoardCoordinate)
}

class BoardView: UIView {
    
    var dataSource: BoardViewDataSource?
    var delegate: BoardViewDelegate?
    fileprivate var imageDict: [BoardCoordinate : UIImageView]
    
    override init(frame: CGRect) {
        imageDict = [:]
        
        super.init(frame: frame)
    
        let numberOfBoardSpaces = 8
        let boardSize: CGFloat = self.bounds.width
        let boardSpaceSize: CGFloat = floor(boardSize / CGFloat(numberOfBoardSpaces))
        let boardBorder: UIView = UIView(frame: CGRect(x: -0.5, y: -0.5, width: boardSpaceSize * 8 + 1, height: boardSpaceSize * 8 + 1))
        
        // Add outside frame
        boardBorder.layer.borderWidth = 0.5
        boardBorder.layer.borderColor = UIColor.black.cgColor
        self.addSubview(boardBorder)
        
        for column in 0...7 {
            for row in 0...7 {
                let coordinate = try! BoardCoordinate(column: column, row: row)
                let tag: Int = column + (row * 8)
                let xPos = boardSpaceSize * CGFloat(column)
                let yPos = boardSpaceSize * CGFloat(row)
                let boardSpaceImageView = UIImageView(frame: CGRect(x: xPos, y: yPos, width: boardSpaceSize, height: boardSpaceSize))
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BoardView.boardSpaceTapped))
                
                boardSpaceImageView.tag = tag
                boardSpaceImageView.layer.borderWidth = 0.5
                boardSpaceImageView.layer.borderColor = UIColor.black.cgColor
                boardSpaceImageView.isUserInteractionEnabled = true
                boardSpaceImageView.addGestureRecognizer(tapRecognizer)
                imageDict[coordinate] = boardSpaceImageView
                
                self.addSubview(boardSpaceImageView)                
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func updateBoard() {
        for (coordinate, imageView) in imageDict {
            imageView.backgroundColor = dataSource?.backgroundColorForSpace(at: coordinate)
            imageView.image = dataSource?.imageForSpace(at: coordinate)?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = dataSource?.tintForPawn(at: coordinate)
        }
    }
    
    func boardSpaceTapped(_ sender: UITapGestureRecognizer) {
        if let boardSpaceImageView = sender.view {
            let tag = boardSpaceImageView.tag
            let coordinate = try! BoardCoordinate(column: tag % 8, row: tag / 8)
            self.delegate?.boardSpaceWasTapped(at: coordinate)
        }
    }
}
