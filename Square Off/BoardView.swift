//
//  BoardView.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

protocol BoardViewDataSource {
    func imageForSpace(at coordinate: BoardCoordinate) -> UIImage?
    func highlightForSpace(at coordinate: BoardCoordinate) -> UIColor
}

protocol BoardViewDelegate {
    func pawnLongPressBegan(at coordinate: BoardCoordinate, with touchLocation: CGPoint)
    func pawnLongPressChanged(at location: CGPoint)
    func pawnLongPressEnded(at targetBoardCoordinage: BoardCoordinate, from sourceBoardCoordinate: BoardCoordinate)
    func boardSpaceTapped(at coordinate: BoardCoordinate)
}

class BoardView: UIView {

    var dataSource: BoardViewDataSource?
    var delegate: BoardViewDelegate?
    
    private var pawnDict: [BoardCoordinate : UIImageView]
    private var highlightDict: [BoardCoordinate : UIImageView]
    
    override init(frame: CGRect) {
        pawnDict = [:]
        highlightDict = [:]
        
        super.init(frame: frame)
        
        let backgroundFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let background = UIImageView(frame: backgroundFrame)
        background.contentMode = .scaleToFill
        background.image = #imageLiteral(resourceName: "Board")
        addSubview(background)
        
        // Pawn image view spacing
        let pawnTopMargin: CGFloat = bounds.height * (5/308)
        let pawnSideMargin: CGFloat = bounds.width * (5/304)
        let pawnTopPadding: CGFloat = bounds.height * (2/308)
        let pawnSidePadding: CGFloat = bounds.width * (6/304)
        let pawnHeight: CGFloat = bounds.height * (48/308)
        let pawnWidth: CGFloat = bounds.width * (44/304)
        
        // Highlight image view spacing
        let highlightTopMargin: CGFloat = bounds.height * (8/308)
        let highlightSideMargin: CGFloat = bounds.width * (4/304)
        let highlightTopPadding: CGFloat = bounds.height * (4/308)
        let highlightSidePadding: CGFloat = bounds.width * (4/304)
        let highlightHeight: CGFloat = bounds.height * (46/308)
        let highlightWidth: CGFloat = bounds.width * (46/304)
        
        for column in 0..<Constants.numberOfBoardSpaces {
            for row in 0..<Constants.numberOfBoardSpaces {
                let coordinate = try! BoardCoordinate(column: column, row: row)
                let tag: Int = column + (row * Constants.numberOfBoardSpaces)
                
                // Generate highlights
                let highlightXPos = (highlightWidth + highlightSidePadding) * CGFloat(column) + highlightSideMargin
                let highlightYPos = (highlightHeight + highlightTopPadding) * CGFloat(row) + highlightTopMargin
                let highlightImageView = UIImageView(frame: CGRect(x: highlightXPos, y: highlightYPos, width: highlightWidth, height: highlightHeight))
                
                highlightImageView.backgroundColor = UIColor.clear
                highlightImageView.layer.cornerRadius = 8
                
                highlightDict[coordinate] = highlightImageView
                
                addSubview(highlightImageView)
                
                // Generate pawns
                let pawnXPos = (pawnWidth + pawnSidePadding) * CGFloat(column) + pawnSideMargin
                let pawnYPos = (pawnHeight + pawnTopPadding) * CGFloat(row) + pawnTopMargin
                let pawnImageView = UIImageView(frame: CGRect(x: pawnXPos, y: pawnYPos, width: pawnWidth, height: pawnHeight))
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BoardView.boardSpaceTapped(_:)))
                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(BoardView.pawnLongPressed(_:)))
                longPressRecognizer.minimumPressDuration = 0.25
                
                pawnImageView.tag = tag
                pawnImageView.isUserInteractionEnabled = true
                pawnImageView.addGestureRecognizer(tapRecognizer)
                pawnImageView.addGestureRecognizer(longPressRecognizer)
                pawnImageView.backgroundColor = UIColor.clear
                
                pawnDict[coordinate] = pawnImageView
                
                addSubview(pawnImageView)
                
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Do not create BoardView in Interface Builder.")
    }
    
    func updateBoard() {
        for (coordinate, highlight) in highlightDict {
            highlight.backgroundColor = dataSource?.highlightForSpace(at: coordinate)
        }
        for (coordinate, pawn) in pawnDict {
            pawn.image = dataSource?.imageForSpace(at: coordinate)
        }
    }
    
    func boardSpaceTapped(_ sender: UITapGestureRecognizer) {
        if let boardSpaceImageView = sender.view {
            let tag = boardSpaceImageView.tag
            let coordinate = try! BoardCoordinate(column: tag % Constants.numberOfBoardSpaces,
                                                  row: tag / Constants.numberOfBoardSpaces)
            self.delegate?.boardSpaceTapped(at: coordinate)
        }
    }
    
    func pawnLongPressed(_ sender: UILongPressGestureRecognizer) {
        if let pawn = sender.view as? UIImageView {
            let startTag = pawn.tag
            let coordinate = try! BoardCoordinate(column: startTag % Constants.numberOfBoardSpaces,
                                                  row: startTag / Constants.numberOfBoardSpaces)
            switch sender.state {
            case .began:
                self.delegate?.pawnLongPressBegan(at: coordinate, with: sender.location(in: self.superview))
            case .changed:
                delegate?.pawnLongPressChanged(at: sender.location(in: self.superview))
            case .ended:
                let targetBoardCoordinate = nearestBoardCoordinate(sender.location(in: self), from: coordinate)
                delegate?.pawnLongPressEnded(at: targetBoardCoordinate, from: coordinate)
            default:
                break
            }
        }
    }
    
    func nearestBoardCoordinate(_ touchLocation: CGPoint, from originalBoardCoordinate: BoardCoordinate) -> BoardCoordinate {
        var boardCoordinate: BoardCoordinate!
        var closestDistance: CGFloat = CGFloat.greatestFiniteMagnitude
        
        // Touch is in BoardView
        if self.bounds.contains(touchLocation) {
            for (coordinate, image) in pawnDict {
                // Touch is in board space
                if image.frame.contains(touchLocation) {
                    return coordinate
                }
                let distance = image.frame.center.distanceTo(touchLocation)
                if distance < closestDistance {
                    closestDistance = distance
                    boardCoordinate = coordinate
                }
            }
        } else {
            return originalBoardCoordinate
        }
        
        return boardCoordinate
    }

}

extension CGRect {
    var center: CGPoint {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return CGPoint(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}

extension CGPoint {
    func distanceTo(_ point: CGPoint) -> CGFloat {
        let xDist = self.x - point.x
        let yDist = self.y - point.y
        return CGFloat(sqrt(pow(xDist,2) + pow(yDist,2)))
    }
}
