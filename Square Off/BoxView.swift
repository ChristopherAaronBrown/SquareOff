//
//  BoxView.swift
//  Square Off
//
//  Created by Chris Brown on 9/9/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

protocol BoxViewDataSource {
    func totalGemsInHand() -> Int
    func playerColor() -> UIColor
}

protocol BoxViewDelegate {
    func tileTapped(at index: Int)
}

class BoxView: UIView {
    
    var dataSource: BoxViewDataSource?
    var delegate: BoxViewDelegate?
    
    override func layoutSubviews() {
        
        let totalGems: Int = (dataSource?.totalGemsInHand())!
        let purchaseTileWidth: CGFloat = floor((self.bounds.width - 50) / 4)
        let purchaseTileHeight: CGFloat = purchaseTileWidth
        let costLabelWidth: CGFloat = purchaseTileWidth
        let costLabelHeight: CGFloat = 15
        var purchasable: Bool = false
        
        for column in 0..<4 {
            for row in 0..<4 {
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BoxView.tileTapped))
                
                // PurchaseTile properties
                let purchaseTilePadding: CGFloat = (self.bounds.height - 4 * (purchaseTileHeight + costLabelHeight + 5)) / 3
                let purchaseTileXPos: CGFloat = (CGFloat(column) * CGFloat(purchaseTileWidth + 10)) + 10
                let purchaseTileYPos: CGFloat = (CGFloat(row) * CGFloat(purchaseTileHeight + costLabelHeight + purchaseTilePadding))
                let purchaseTile = UIImageView(frame: CGRect(x: purchaseTileXPos, y: purchaseTileYPos, width: purchaseTileWidth, height: purchaseTileHeight))
                
                // CostLabel properties
                let costLabelXPos: CGFloat = purchaseTileXPos
                let costLabelYPos: CGFloat = purchaseTileYPos + purchaseTileHeight + 5
                let costLabel = UILabel(frame: CGRect(x: costLabelXPos, y: costLabelYPos, width: costLabelWidth, height: costLabelHeight))
                
                purchaseTile.tag = column + (row * 4)
                costLabel.tag = purchaseTile.tag + 16
                
                // TODO: Make this more concise
                switch purchaseTile.tag {
                case 0:
                    purchaseTile.image = UIImage(named: "Gem1Tile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(GemTile.init(value: 1).cost)"
                    purchasable = totalGems >= GemTile.init(value: 1).cost
                case 1:
                    purchaseTile.image = UIImage(named: "Gem2Tile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(GemTile.init(value: 2).cost)"
                    purchasable = totalGems >= GemTile.init(value: 2).cost
                case 2:
                    purchaseTile.image = UIImage(named: "Gem3Tile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(GemTile.init(value: 3).cost)"
                    purchasable = totalGems >= GemTile.init(value: 3).cost
                case 3:
                    purchaseTile.image = UIImage(named: "JumpTile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(JumpTile.init().cost)"
                    purchasable = totalGems >= JumpTile.init().cost
                case 4:
                    purchaseTile.image = UIImage(named: "AttackTile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(AttackTile.init().cost)"
                    purchasable = totalGems >= AttackTile.init().cost
                case 5:
                    purchaseTile.image = UIImage(named: "DefendTile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(DefendTile.init().cost)"
                    purchasable = totalGems >= DefendTile.init().cost
                case 6:
                    purchaseTile.image = UIImage(named: "BurnTile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(BurnTile.init().cost)"
                    purchasable = totalGems >= BurnTile.init().cost
                case 7:
                    purchaseTile.image = UIImage(named: "ResurrectTile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(ResurrectTile.init().cost)"
                    purchasable = totalGems >= ResurrectTile.init().cost
                case 8:
                    purchaseTile.image = UIImage(named: "Straight1Tile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(Straight1Tile.init().cost)"
                    purchasable = totalGems >= Straight1Tile.init().cost
                case 9:
                    purchaseTile.image = UIImage(named: "Diagonal1Tile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(Diagonal1Tile.init().cost)"
                    purchasable = totalGems >= Diagonal1Tile.init().cost
                case 10:
                    purchaseTile.image = UIImage(named: "KnightLeftTile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(KnightLeftTile.init().cost)"
                    purchasable = totalGems >= KnightLeftTile.init().cost
                case 11:
                    purchaseTile.image = UIImage(named: "ZigZagLeftTile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(ZigZagLeftTile.init().cost)"
                    purchasable = totalGems >= ZigZagLeftTile.init().cost
                case 12:
                    purchaseTile.image = UIImage(named: "Straight2Tile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(Straight2Tile.init().cost)"
                    purchasable = totalGems >= Straight2Tile.init().cost
                case 13:
                    purchaseTile.image = UIImage(named: "Diagonal2Tile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(Diagonal2Tile.init().cost)"
                    purchasable = totalGems >= Diagonal2Tile.init().cost
                case 14:
                    purchaseTile.image = UIImage(named: "KnightRightTile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(KnightRightTile.init().cost)"
                    purchasable = totalGems >= KnightRightTile.init().cost
                case 15:
                    purchaseTile.image = UIImage(named: "ZigZagRightTile")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    costLabel.text = "COST: \(ZigZagRightTile.init().cost)"
                    purchasable = totalGems >= ZigZagRightTile.init().cost
                default:
                    break
                }
                
                if purchasable {
                    purchaseTile.tintColor = dataSource?.playerColor()
                    costLabel.textColor = dataSource?.playerColor()
                    purchaseTile.addGestureRecognizer(tapRecognizer)
                } else {
                    purchaseTile.tintColor = UIColor.lightGray
                    costLabel.textColor = UIColor.lightGray
                }
                
                purchaseTile.isUserInteractionEnabled = true
                purchaseTile.contentMode = .scaleAspectFit
                costLabel.textAlignment = .center
                costLabel.font = UIFont(name: "Anita-semi-square", size: 15)
                
                self.addSubview(purchaseTile)
                self.addSubview(costLabel)
            }
        }
    }
    
    func tileTapped(_ sender: UITapGestureRecognizer) {
        if let purchaseTile = sender.view {
            self.delegate?.tileTapped(at: purchaseTile.tag)
        }
    }
}
