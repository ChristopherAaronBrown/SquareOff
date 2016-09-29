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
    private var tagTileMap: [Int:Tile]
    
    override init(frame: CGRect) {
        self.tagTileMap = [
             0: GemTile(value: 1),
             1: GemTile(value: 2),
             2: GemTile(value: 3),
             3: JumpTile(),
             4: AttackTile(),
             5: DefendTile(),
             6: BurnTile(),
             7: ResurrectTile(),
             8: Straight1Tile(),
             9: Diagonal1Tile(),
            10: KnightLeftTile(),
            11: ZigZagLeftTile(),
            12: Straight2Tile(),
            13: Diagonal2Tile(),
            14: KnightRightTile(),
            15: ZigZagRightTile(),
        ]
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                
                let taggedTile = tagTileMap[purchaseTile.tag]
                purchaseTile.image = UIImage(named: (taggedTile?.imageName)!)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                costLabel.text = "COST: \((taggedTile?.cost)!)"
                purchasable = totalGems >= (taggedTile?.cost)!
                
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
