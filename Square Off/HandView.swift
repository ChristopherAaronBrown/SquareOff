//
//  HandView.swift
//  Square Off
//
//  Created by Chris Brown on 2/13/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

protocol HandViewDataSource {
    func numberOfCards() -> Int
    func currentPlayer() -> Player
}

protocol HandViewDelegate {
    func handViewSlotWasTapped(at index: Int)
}

class HandView: UIView {
    
    var dataSource: HandViewDataSource!
    var delegate: HandViewDelegate!
    
    private var cardViews: [CardView] = []

    func refresh() {
        let player = dataSource.currentPlayer()
        
        // Remove previous hand
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        cardViews.removeAll()
        
        let numCards: Int = dataSource.numberOfCards()
        
        let cardHeight: CGFloat = bounds.height * (70/110)
        let cardWidth: CGFloat = bounds.width * (50/320)
        let padding: CGFloat = (bounds.width - (CGFloat(Constants.handLimit) * cardWidth)) / CGFloat(Constants.handLimit + 1)
        let yPos: CGFloat = (bounds.height - cardHeight) / 3
        
        for index in 0..<numCards {
            let icon: UIImage = cardIcon(at: index)!
            let xPos: CGFloat = (cardWidth + padding) * CGFloat(index) + padding
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(slotImageTapped(_:)))
            let cardFrame = CGRect(x: xPos, y: yPos, width: cardWidth, height: cardHeight)
            let cardView = CardView(frame: cardFrame, player: player, icon: icon)
            
            addSubview(cardView)
            
            cardView.tag = index
            cardView.addGestureRecognizer(tapRecognizer)
            
            cardViews.append(cardView)
        }
    }
    
    func slotImageTapped(_ sender: UITapGestureRecognizer) {
        if let handSlotView = sender.view {
            delegate.handViewSlotWasTapped(at: handSlotView.tag)
        }
    }
    
    func animateDiscard(to point: CGPoint, callback: @escaping AnimationCallback) {
        let pointInHandView = convert(point, from: superview)
        
        let duration: TimeInterval = 0.08
        var delay: TimeInterval = 0
        var index = 0
        for handSlotImageView in self.cardViews {
            UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
                    handSlotImageView.center = pointInHandView
            }) { (finished) in
                callback(index == self.cardViews.count - 1)
                index += 1
            }
            delay += duration
        }
    }
    
    func animateDeal(from point: CGPoint, callback: @escaping AnimationCallback) {
//        let pointInHandView = convert(point, from: superview)
        let player = dataSource.currentPlayer()
        
        // Remove previous hand
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        cardViews.removeAll()
        
        let numCards: Int = dataSource?.numberOfCards() ?? 0
        
        let cardHeight: CGFloat = bounds.height * (70/110)
        let cardWidth: CGFloat = bounds.width * (50/320)
        let padding: CGFloat = (bounds.width - (CGFloat(Constants.handLimit) * cardWidth)) / CGFloat(Constants.handLimit + 1)
        let yPos: CGFloat = (bounds.height - cardHeight) / 3
        
        for index in 0..<numCards {
            let icon: UIImage = cardIcon(at: index)!
            let xPos: CGFloat = (cardWidth + padding) * CGFloat(index) + padding
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(slotImageTapped(_:)))
            let cardFrame = CGRect(x: xPos, y: yPos, width: cardWidth, height: cardHeight)
            let cardView = CardView(frame: cardFrame, player: player, icon: icon)
            
            addSubview(cardView)
            
            cardView.tag = index
            cardView.addGestureRecognizer(tapRecognizer)
            
            cardViews.append(cardView)
        }
        
        
//        // Spacing variables for placing card image views
//        let topMargin: CGFloat = bounds.height * (5/58)
//        let sideMargin: CGFloat = bounds.width * (5/254)
//        let sidePadding: CGFloat = bounds.width * (6/254)
//        let handSlotHeight: CGFloat = bounds.height * (48/58)
//        let handSlotWidth: CGFloat = bounds.width * (44/254)
//        
//        var centers: [CGPoint] = []
//        
//        // Calculate destination but add at pointInHandView
//        for index in 0..<numCards {
//            let xPos: CGFloat = (handSlotWidth + sidePadding) * CGFloat(index) + sideMargin
//            let yPos: CGFloat = topMargin
//            var frame =  CGRect(x: xPos, y: yPos, width: handSlotWidth, height: handSlotHeight)
//            centers.append(frame.center)
//            frame.center = pointInHandView
//            
//            let handSlotImageView = UIImageView(frame: frame)
//            handSlotImageView.image = dataSource?.imageForCard(at: index)
//            handSlotImageView.tag = index
//            
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.slotImageTapped))
//            handSlotImageView.addGestureRecognizer(tapRecognizer)
//            handSlotImageView.isUserInteractionEnabled = true
//            
//            handSlotImageViews.append(handSlotImageView)
//            
//            addSubview(handSlotImageView)
//        }
//        
//        let duration: TimeInterval = 0.1
//        var delay: TimeInterval = 0
//        var index = 0
//        for handSlotImageView in handSlotImageViews {
//            UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
//                handSlotImageView.center = centers[index]
//            }) { (finished) in
//                callback(index == self.handSlotImageViews.count - 1)
//                
//            }
//            index += 1
//            delay += duration
//        }
    }
    
    func cardIcon(at index: Int) -> UIImage? {
        let hand = dataSource.currentPlayer().hand
        let type = type(of: hand.cards[index])
        
        if type == GemCard.self {
            switch hand.cards[index].cost {
            case 6:
                return #imageLiteral(resourceName: "TripleGem-Card")
            case 3:
                return #imageLiteral(resourceName: "DoubleGem-Card")
            default:
                return #imageLiteral(resourceName: "SingleGem-Card")
            }
        } else if type == JumpCard.self {
            return #imageLiteral(resourceName: "Jump-Card")
        } else if type == AttackCard.self {
            return #imageLiteral(resourceName: "Attack-Card")
        } else if type == DefendCard.self {
            return #imageLiteral(resourceName: "Defend-Card")
        } else if type == BurnCard.self {
            return #imageLiteral(resourceName: "Burn-Card")
        } else if type == ResurrectCard.self {
            return #imageLiteral(resourceName: "Resurrect-Card")
        } else if type == SingleStraightCard.self {
            return #imageLiteral(resourceName: "SingleStraight-Card")
        } else if type == SingleDiagonalCard.self {
            return #imageLiteral(resourceName: "SingleDiagonal-Card")
        } else if type == DoubleStraightCard.self {
            return #imageLiteral(resourceName: "DoubleStraight-Card")
        } else if type == DoubleDiagonalCard.self {
            return #imageLiteral(resourceName: "DoubleDiagonal-Card")
        } else if type == ZigZagLeftCard.self {
            return #imageLiteral(resourceName: "ZigZagLeft-Card")
        } else if type == ZigZagRightCard.self {
            return #imageLiteral(resourceName: "ZigZagRight-Card")
        } else if type == KnightLeftCard.self {
            return #imageLiteral(resourceName: "KnightLeft-Card")
        } else if type == KnightRightCard.self {
            return #imageLiteral(resourceName: "KnightRight-Card")
        } else {
            return nil
        }
    }
    
}
