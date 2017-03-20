//
//  BoardView.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

protocol BoardViewDataSource {
    func pawnViewForSpace(at coordinate: Coordinate) -> PawnView?
    func highlightForSpace(at coordinate: Coordinate) -> UIColor
    func currentBoard() -> Board
}

protocol BoardViewDelegate {
    func pawnLongPressBegan(at coordinate: Coordinate, with touchLocation: CGPoint)
    func pawnLongPressChanged(at location: CGPoint)
    func pawnLongPressEnded(at targetBoardCoordinage: Coordinate, from sourceBoardCoordinate: Coordinate)
    func boardSpaceTapped(at coordinate: Coordinate)
}

class BoardView: UIView {

    var dataSource: BoardViewDataSource?
    var delegate: BoardViewDelegate?
    
    private let board: Board
    private var pawnDict: [Coordinate:PawnView?]
    private var spaceDict: [Coordinate:UIImageView]
    
    init(frame: CGRect, board: Board) {
        pawnDict = [:]
        spaceDict = [:]
        self.board = board
        
        super.init(frame: frame)
        
        updateBoard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Do not create BoardView in Interface Builder.")
    }
    
    func updateBoard() {
        // Remove subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        // Highlight image view spacing
        let spaceWidth: CGFloat = bounds.width * (46/304)
        let spaceHeight: CGFloat = spaceWidth
        let spaceMargin: CGFloat = (bounds.width - CGFloat(board.count) * spaceWidth) / CGFloat(board.count - 1)
        
        // Pawn image view spacing
        let pawnTop: CGFloat = bounds.height * (-3/304)
        let pawnMargin: CGFloat = bounds.width * (1/304)
        let pawnHeight: CGFloat = bounds.height * (48/304)
        let pawnWidth: CGFloat = bounds.width * (44/304)
        
        for column in 0..<board.count {
            for row in 0..<board.count {
                let coordinate = try! Coordinate(column: column, row: row)
                let tag: Int = column + (row * board.count)
                
                // Generate highlights
                let spaceXPos = (spaceWidth + spaceMargin) * CGFloat(column)
                let spaceYPos = (spaceHeight + spaceMargin) * CGFloat(row)
                let spaceImageView = UIImageView(frame: CGRect(x: spaceXPos, y: spaceYPos, width: spaceWidth, height: spaceHeight))
                
                spaceImageView.backgroundColor = Colors.grey
                spaceImageView.layer.cornerRadius = 8
                
                spaceDict[coordinate] = spaceImageView
                
                addSubview(spaceImageView)
                
                // Generate pawns
                if let pawn = board.getSpace(coordinate).pawn {
                    let pawnXPos = spaceXPos + pawnMargin
                    let pawnYPos = spaceYPos + pawnTop
                    let pawnFrame = CGRect(x: pawnXPos, y: pawnYPos, width: pawnWidth, height: pawnHeight)
                    let pawnView = PawnView(frame: pawnFrame, owner: pawn.owner)
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(boardSpaceTapped))
                    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pawnLongPressed))
                    longPressRecognizer.minimumPressDuration = 0
                    
                    pawnView.tag = tag
                    pawnView.isUserInteractionEnabled = true
                    pawnView.addGestureRecognizer(tapRecognizer)
                    pawnView.addGestureRecognizer(longPressRecognizer)
                    
                    pawnDict[coordinate] = pawnView
                    
                    addSubview(pawnView)
                }
            }
        }
    }
    
    @objc private func boardSpaceTapped(_ sender: UITapGestureRecognizer) {
        if let boardSpaceImageView = sender.view {
            let tag = boardSpaceImageView.tag
            let coordinate = try! Coordinate(column: tag % board.count, row: tag / board.count)
            self.delegate?.boardSpaceTapped(at: coordinate)
        }
    }
    
    @objc private func pawnLongPressed(_ sender: UILongPressGestureRecognizer) {
        if let pawn = sender.view as? PawnView {
            let startTag = pawn.tag
            let coordinate = try! Coordinate(column: startTag % board.count, row: startTag / board.count)
            switch sender.state {
            case .began:
                if let pawnView = pawnDict[coordinate] {
                    pawnView?.alpha = 0.3
                }
                delegate?.pawnLongPressBegan(at: coordinate, with: sender.location(in: superview))
            case .changed:
                delegate?.pawnLongPressChanged(at: sender.location(in: superview))
            case .ended:
                let targetBoardCoordinate = nearestBoardCoordinate(sender.location(in: self), from: coordinate)
                delegate?.pawnLongPressEnded(at: targetBoardCoordinate, from: coordinate)
            default:
                break
            }
        }
    }
    
    private func nearestBoardCoordinate(_ touchLocation: CGPoint, from originalBoardCoordinate: Coordinate) -> Coordinate {
        var boardCoordinate: Coordinate!
        var closestDistance: CGFloat = CGFloat.greatestFiniteMagnitude
        
        // Touch is in BoardView
        if bounds.contains(touchLocation) {
            for (coordinate, pawnView) in pawnDict {
                // Touch is in board space
                if pawnView!.frame.contains(touchLocation) {
                    return coordinate
                }
                let distance = pawnView!.frame.center.distanceTo(touchLocation)
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

