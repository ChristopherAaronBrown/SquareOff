//
//  BoardView.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

protocol BoardViewDataSource {
    func highlightForSpace(at coordinate: Coordinate) -> UIColor
    func currentPlayer() -> Player
    func currentBoard() -> Board
}

protocol BoardViewDelegate {
    func pawnLongPressBegan(at coordinate: Coordinate, at location: CGPoint)
    func pawnLongPressChanged(at location: CGPoint)
    func pawnLongPressEnded(at target: Coordinate, from source: Coordinate)
    func spaceTapped(at coordinate: Coordinate)
}

class BoardView: UIView {

    var dataSource: BoardViewDataSource?
    var delegate: BoardViewDelegate?
    
//    private let board: Board
    private var spacesCount: Int {
        return Constant.numberOfSpaces
    }
    private var pawnDict: [Coordinate:PawnView?] = [:]
    private var spaceDict: [Coordinate:UIImageView] = [:]
    
    private var spaceWidth: CGFloat = 0
    private var spaceHeight: CGFloat = 0
    private var spaceMargin: CGFloat = 0
    private var pawnTop: CGFloat = 0
    private var pawnMargin: CGFloat = 0
    private var pawnHeight: CGFloat = 0
    private var pawnWidth: CGFloat = 0
    
    override func layoutSubviews() {
        let spaces: CGFloat = CGFloat(Constant.numberOfSpaces)
        
        pawnDict = [:]
        spaceDict = [:]
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
        spaceMargin = bounds.width * (4/296)
        spaceWidth = (bounds.width - (spaces - 1) * spaceMargin) / spaces
        spaceHeight = spaceWidth
        pawnTop = bounds.height * (-3/299)
        pawnMargin = bounds.width * (1/296)
        pawnHeight = bounds.height * (48/299)
        pawnWidth = bounds.width * (44/296)
        
        for column in 0..<Constant.numberOfSpaces {
            for row in 0..<Constant.numberOfSpaces {
                let coordinate = try! Coordinate(column: column, row: row)
                drawSpace(at: coordinate)
                drawPawn(at: coordinate)
            }
        }
    }
    
    func updateBoard() {
        
        guard let board = dataSource?.currentBoard() else {
            return
        }
        
        for subview in subviews {
            if let pawnView = subview as? PawnView {
                pawnView.removeFromSuperview()
            }
        }
        
        pawnDict = [:]
        
        for column in 0..<Constant.numberOfSpaces {
            for row in 0..<Constant.numberOfSpaces {
                let coordinate = try! Coordinate(column: column, row: row)
                let space = board.getSpace(coordinate)
                if space.hasPawn {
                    drawPawn(at: coordinate)
                }
            }
        }
        
        updateHighlights()
    }
    
    func updateHighlights() {
        for (coordinate, spaceImageView) in spaceDict {
            spaceImageView.backgroundColor = dataSource?.highlightForSpace(at: coordinate)
        }
    }
    
    private func drawSpace(at coordinate: Coordinate) {
        let spaceXPos = (spaceWidth + spaceMargin) * CGFloat(coordinate.column)
        let spaceYPos = (spaceHeight + spaceMargin) * CGFloat(coordinate.row)
        let spaceImageView = UIImageView(frame: CGRect(x: spaceXPos, y: spaceYPos, width: spaceWidth, height: spaceHeight))
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(spaceTapped))
        let tag: Int = coordinate.column + (coordinate.row * Constant.numberOfSpaces)
        
        spaceImageView.addGestureRecognizer(tapRecognizer)
        spaceImageView.isUserInteractionEnabled = true
        spaceImageView.backgroundColor = dataSource?.highlightForSpace(at: coordinate)
        spaceImageView.layer.cornerRadius = 8
        spaceImageView.tag = tag
        
        addSubview(spaceImageView)
        
        spaceDict[coordinate] = spaceImageView
    }
    
    private func drawPawn(at coordinate: Coordinate) {
        
        guard let board = dataSource?.currentBoard(), let owner = board.getSpace(coordinate).pawn?.owner else {
            return
        }
        
        let spaceXPos = (spaceWidth + spaceMargin) * CGFloat(coordinate.column)
        let spaceYPos = (spaceHeight + spaceMargin) * CGFloat(coordinate.row)
        let pawnXPos = spaceXPos + pawnMargin
        let pawnYPos = spaceYPos + pawnTop
        let pawnFrame = CGRect(x: pawnXPos, y: pawnYPos, width: pawnWidth, height: pawnHeight)
        let pawnView = PawnView(frame: pawnFrame, owner: owner)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pawnLongPressed))
        let tag: Int = coordinate.column + (coordinate.row * Constant.numberOfSpaces)
        
        longPressRecognizer.minimumPressDuration = 0
        pawnView.isUserInteractionEnabled = true
        pawnView.tag = tag
        
        if owner == dataSource!.currentPlayer() {
            pawnView.addGestureRecognizer(longPressRecognizer)
        }
        
        addSubview(pawnView)
        
        pawnDict[coordinate] = pawnView
    }
    
    @objc private func spaceTapped(_ sender: UITapGestureRecognizer) {
        if let spaceImageView = sender.view {
            let tag = spaceImageView.tag
            let coordinate = try! Coordinate(column: tag % Constant.numberOfSpaces, row: tag / Constant.numberOfSpaces)
            delegate?.spaceTapped(at: coordinate)
        }
    }
    
    @objc private func pawnLongPressed(_ sender: UILongPressGestureRecognizer) {
        if let pawnView = sender.view as? PawnView {
            let tag = pawnView.tag
            let coordinate = try! Coordinate(column: tag % Constant.numberOfSpaces, row: tag / Constant.numberOfSpaces)
            switch sender.state {
            case .began:
                pawnView.alpha = 0.3
                delegate?.pawnLongPressBegan(at: coordinate, at: sender.location(in: superview))
            case .changed:
                delegate?.pawnLongPressChanged(at: sender.location(in: superview))
            case .ended:
                let target = nearestCoordinate(sender.location(in: self), from: coordinate)
                delegate?.pawnLongPressEnded(at: target, from: coordinate)
            default:
                break
            }
        }
    }
    
    private func nearestCoordinate(_ touchLocation: CGPoint, from source: Coordinate) -> Coordinate {
        var target: Coordinate!
        var closestDistance: CGFloat = CGFloat.greatestFiniteMagnitude
        
        // Touch is in BoardView
        if bounds.contains(touchLocation) {
            for (coordinate, spaceImageView) in spaceDict {
                // Touch is in board space
                if spaceImageView.frame.contains(touchLocation) {
                    return coordinate
                }
                let distance = spaceImageView.frame.center.distanceTo(touchLocation)
                if distance < closestDistance {
                    closestDistance = distance
                    target = coordinate
                }
            }
        } else {
            return source
        }
        
        return target
    }

}

