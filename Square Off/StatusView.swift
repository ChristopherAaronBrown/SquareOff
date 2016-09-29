//
//  StatusView.swift
//  Square Off
//
//  Created by Chris Brown on 9/1/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

protocol StatusViewDataSource {
    func numTilesInBag() -> Int
    func numTilesInDiscard() -> Int
    func playerColor() -> UIColor
}

protocol StatusViewDelegate {
    func endTurnPressed()
}

class StatusView: UIView {
    
    var dataSource: StatusViewDataSource?
    var delegate: StatusViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        // Add bag icon
        let bagSize: CGFloat = (self.bounds.size.width - 60) / 5
        let bagXPos: CGFloat = 10
        let bagYPos: CGFloat = (self.bounds.size.height - bagSize) / 2
        let bagImageView = UIImageView(frame: CGRect(x: bagXPos, y: bagYPos, width: bagSize, height: bagSize))
        
        bagImageView.image = UIImage(named: "BagIcon")?.withRenderingMode(.alwaysTemplate)
        bagImageView.contentMode = .scaleAspectFit
        bagImageView.tintColor = dataSource?.playerColor()
        
        self.addSubview(bagImageView)
        
        let bagLabelString: String = "\(dataSource!.numTilesInBag())"
        let bagLabelNSString: NSString = bagLabelString as NSString
        let bagLabelSize: CGSize = bagLabelNSString.size(attributes: [NSFontAttributeName: UIFont(name: "Anita-semi-square", size: 25)!])
        let bagLabelXPos: CGFloat = bagXPos + ((bagSize - bagLabelSize.width) / 2) + 2
        let bagLabelYPos: CGFloat = bagYPos + (bagSize / 2) - (bagLabelSize.height / 4)
        let bagLabel = UILabel(frame: CGRect(x: bagLabelXPos, y: bagLabelYPos, width: bagLabelSize.width, height: bagLabelSize.height))
        bagLabel.font = UIFont(name: "Anita-semi-square", size: 25)
        bagLabel.text = bagLabelString
        bagLabel.textColor = dataSource?.playerColor()
        
        self.addSubview(bagLabel)
        
        // Add discard icon
        let discardImage = UIImage(named: "DiscardIcon")?.withRenderingMode(.alwaysTemplate)
        let discardXPos: CGFloat = self.bounds.size.width - bagSize - 10
        let discardYPos: CGFloat = bagYPos
        let discardSize: CGFloat = bagSize
        let discardImageView = UIImageView(frame: CGRect(x: discardXPos, y: discardYPos, width: discardSize, height: discardSize))
        
        discardImageView.image = discardImage
        discardImageView.contentMode = .scaleAspectFit
        discardImageView.tintColor = dataSource?.playerColor()
        
        self.addSubview(discardImageView)
        
        let discardLabelString: String = "\(dataSource!.numTilesInDiscard())"
        let discardLabelNSString: NSString = discardLabelString as NSString
        let discardLabelSize: CGSize = discardLabelNSString.size(attributes: [NSFontAttributeName: UIFont(name: "Anita-semi-square", size: 25)!])
        let discardLabelXPos: CGFloat = discardXPos + ((discardSize - discardLabelSize.width) / 2) + 2
        let discardLabelYPos: CGFloat = discardYPos + ((discardSize - discardLabelSize.height) / 2)
        let discardLabel = UILabel(frame: CGRect(x: discardLabelXPos, y: discardLabelYPos, width: discardLabelSize.width, height: discardLabelSize.height))
        discardLabel.font = UIFont(name: "Anita-semi-square", size: 25)
        discardLabel.text = discardLabelString
        discardLabel.textColor = dataSource?.playerColor()
        
        self.addSubview(discardLabel)
        
        // Add End Turn button
        let endTurnXPos: CGFloat = 10 + bagSize * 1.5
        let endTurnYPos: CGFloat = bagYPos
        let endTurnWidth: CGFloat = (self.bounds.size.width - 20 - (bagSize * 3))
        let endTurnHeight: CGFloat = bagSize
        let endTurn = UIButton(frame: CGRect(x: endTurnXPos, y: endTurnYPos, width: endTurnWidth, height: endTurnHeight))
        endTurn.backgroundColor = dataSource?.playerColor()
        endTurn.layer.cornerRadius = 5
        
        endTurn.setTitle("END TURN", for: UIControlState())
        endTurn.setTitleColor(UIColor.white, for: UIControlState())
        endTurn.titleLabel!.font =  UIFont(name: "Anita-semi-square", size: 20)
        endTurn.addTarget(self, action: #selector(endTurnPressed), for: .touchUpInside)
        
        self.addSubview(endTurn)
    }
    
    func endTurnPressed(_ sender: UIButton!) {
        self.delegate?.endTurnPressed()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
