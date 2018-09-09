//
//  ShopVC.swift
//  Square Off
//
//  Created by Chris Brown on 2/16/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

protocol ShopVCDataSource {
    func currentPlayer() -> Player
    func shopAnimationPoint() -> CGPoint
}

protocol ShopVCDelegate {
    func purchased(card: Card)
}

class ShopVC: UIViewController {

    var dataSource: ShopVCDataSource!
    var delegate: ShopVCDelegate!
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var totalGemsLabel: UILabel!
    private var costLabels: [UILabel] = []
    private var cancelButton: UIButton!
    private var cardTag: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureShop()
        showAnimate()
    }
    
    private func configureShop() {
        let player = dataSource.currentPlayer()
        let totalGems = player.hand.totalGems()
        
        totalGemsLabel.text = "Total Gems: \(totalGems)"
        buyButton.backgroundColor = player.number == 0 ? Colors.player1Light : Colors.player2Light
        
        addCards()
    }
    
    private func addCards() {
        let player = dataSource.currentPlayer()
        let totalGems = player.hand.totalGems()
        let alpha: CGFloat = 0.3

        // Cards
        let topMargin: CGFloat = 8
        let sideMargin: CGFloat = 24
        let cardWidth: CGFloat = view.bounds.width * (50/320)
        let cardHeight: CGFloat = view.bounds.height * (70/568)
//        let topPadding: CGFloat = (view.bounds.height - 60 - 2 * topMargin - 4 * (cardHeight + 20)) / 3
        let topPadding: CGFloat = view.bounds.height * (16/568)
        let sidePadding: CGFloat = (view.bounds.width - 2 * sideMargin - 4 * cardWidth) / 3
        
        
        for index in 0..<16 {
            let column = index % 4
            let row = Int(index / 4)

            let cardView: CardView
            let xPos: CGFloat = sideMargin + CGFloat(column) * (sidePadding + cardWidth)
            let yPos: CGFloat = totalGemsLabel.frame.maxY + topMargin + CGFloat(row) * (topPadding + cardHeight + 20)
            let cardFrame = CGRect(x: xPos, y: yPos, width: cardWidth, height: cardHeight)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cardTapped))

            let labelFrame = CGRect(x: xPos, y: yPos + cardHeight + 8, width: cardWidth, height: 20)
            let costLabel = UILabel(frame: labelFrame)
            costLabel.font = UIFont(name: "Montserrat-Light", size: 16)
            costLabel.adjustsFontSizeToFitWidth = true
            costLabel.textAlignment = .center
            costLabel.textColor = Colors.font
            costLabel.layer.borderWidth = 2
            costLabel.layer.borderColor = UIColor.clear.cgColor
            
            switch ShopCard(rawValue: index)! {
            case .SingleGem:
                costLabel.text = "Cost: 0"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "SingleGem-Card"))
                cardView.addGestureRecognizer(tapRecognizer)
            case .DoubleGem:
                costLabel.text = "Cost: 3"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "DoubleGem-Card"))
                if totalGems >= 3 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .TripleGem:
                costLabel.text = "Cost: 6"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "TripleGem-Card"))
                if totalGems >= 6 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .Jump:
                costLabel.text = "Cost: 4"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "Jump-Card"))
                if totalGems >= 4 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .Attack:
                costLabel.text = "Cost: 4"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "Attack-Card"))
                if totalGems >= 4 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .Defend:
                costLabel.text = "Cost: 4"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "Defend-Card"))
                if totalGems >= 4 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .Burn:
                costLabel.text = "Cost: 4"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "Burn-Card"))
                if totalGems >= 4 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .Resurrect:
                costLabel.text = "Cost: 6"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "Resurrect-Card"))
                if totalGems >= 6 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .SingleStraight:
                costLabel.text = "Cost: 3"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "SingleStraight-Card"))
                if totalGems >= 3 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .SingleDiagonal:
                costLabel.text = "Cost: 3"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "SingleDiagonal-Card"))
                if totalGems >= 3 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .ZigZagLeft:
                costLabel.text = "Cost: 5"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "ZigZagLeft-Card"))
                if totalGems >= 5 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .KnightLeft:
                costLabel.text = "Cost: 5"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "KnightLeft-Card"))
                if totalGems >= 5 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .DoubleStraight:
                costLabel.text = "Cost: 4"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "DoubleStraight-Card"))
                if totalGems >= 4 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .DoubleDiagonal:
                costLabel.text = "Cost: 5"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "DoubleDiagonal-Card"))
                if totalGems >= 5 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .ZigZagRight:
                costLabel.text = "Cost: 5"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "ZigZagRight-Card"))
                if totalGems >= 5 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            case .KnightRight:
                costLabel.text = "Cost: 5"
                cardView = CardView(frame: cardFrame, player: player, icon: #imageLiteral(resourceName: "KnightRight-Card"))
                if totalGems >= 5 {
                    cardView.addGestureRecognizer(tapRecognizer)
                } else {
                    cardView.alpha = alpha
                }
            }
            
            costLabels.append(costLabel)
            cardView.tag = column + (row * 4)
            cardView.isUserInteractionEnabled = true
            
            view.addSubview(cardView)
            view.addSubview(costLabel)
        }
    }
    
    @objc private func cardTapped(_ sender: UITapGestureRecognizer) {
        // Remove outlines from all labels
        for costLabel in costLabels {
            costLabel.layer.borderColor = UIColor.clear.cgColor
        }
        
        if let cardView = sender.view as? CardView {
            let playerNumber = dataSource.currentPlayer().number
            let outlineColor: CGColor = playerNumber == 0 ? Colors.player1Light.cgColor : Colors.player2Light.cgColor
            if cardTag == cardView.tag {
                cardTag = -1
                costLabels[cardView.tag].layer.borderColor = UIColor.clear.cgColor
                buyButton.setTitle("Cancel", for: .normal)
            } else {
                cardTag = cardView.tag
                costLabels[cardView.tag].layer.borderColor = outlineColor
                buyButton.setTitle("Buy", for: .normal)
            }
            animateButton()
        }
    }
    
    private func selectedCard() -> Card {
        switch ShopCard(rawValue: cardTag)! {
        case .SingleGem:
            return GemCard(gem: Gem.Single)
        case .DoubleGem:
            return GemCard(gem: Gem.Double)
        case .TripleGem:
            return GemCard(gem: Gem.Triple)
        case .Jump:
            return JumpCard()
        case .Attack:
            return AttackCard()
        case .Defend:
            return DefendCard()
        case .Burn:
            return BurnCard()
        case .Resurrect:
            return ResurrectCard()
        case .SingleStraight:
            return SingleStraightCard()
        case .SingleDiagonal:
            return SingleDiagonalCard()
        case .ZigZagLeft:
            return ZigZagLeftCard()
        case .KnightLeft:
            return KnightLeftCard()
        case .DoubleStraight:
            return DoubleStraightCard()
        case .DoubleDiagonal:
            return DoubleDiagonalCard()
        case .ZigZagRight:
            return ZigZagRightCard()
        case .KnightRight:
            return KnightRightCard()
        }
    }
    
    @IBAction func buyPressed(_ sender: UIButton) {
        if buyButton.titleLabel?.text == "Buy" {
            delegate.purchased(card: selectedCard())
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func animateButton() {
        let duration: TimeInterval = 0.1
        let scale: CGFloat = 1.1
        
        UIButton.animate(withDuration: duration, animations: { 
            self.buyButton.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { _ in
            self.buyButton.transform = CGAffineTransform.identity
        }
    }
    
    private func showAnimate() {
        let destination = view.center
        
        view.center = dataSource.shopAnimationPoint()
        view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        view.alpha = 0
        UIView.animate(withDuration: 0.25) { 
            self.view.center = destination
            self.view.alpha = 1
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func dismissAnimate() {
        dismiss(animated: true, completion: nil)
    }

}
