//
//  HandView.swift
//  Square Off
//
//  Created by Chris Brown on 2/13/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

protocol HandViewDataSource {
    func numberOfTiles() -> Int
    func imageForTile(at index: Int) -> UIImage?
}

protocol HandViewDelegate {
    func handViewSlotWasTapped(at index: Int)
}

class HandView: UIView {
    
    var dataSource: HandViewDataSource?
    var delegate: HandViewDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Remove previous hand
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let numTiles: Int = dataSource?.numberOfTiles() ?? 0
        
        // Background image
        let backgroundFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let background = UIImageView(frame: backgroundFrame)
        background.image = #imageLiteral(resourceName: "HandSlot")
        background.contentMode = .scaleToFill
        addSubview(background)
        
        let topMargin: CGFloat = bounds.height * (5/58)
        let sideMargin: CGFloat = bounds.width * (5/254)
        let sidePadding: CGFloat = bounds.width * (6/254)
        let handSlotHeight: CGFloat = bounds.height * (48/58)
        let handSlotWidth: CGFloat = bounds.width * (44/254)
        
        for index in 0..<numTiles {
            let xPos: CGFloat = (handSlotWidth + sidePadding) * CGFloat(index) + sideMargin
            let yPos: CGFloat = topMargin
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.slotImageTapped))
            let handSlotImageView = UIImageView(frame: CGRect(x: xPos, y: yPos, width: handSlotWidth, height: handSlotHeight))
            
            handSlotImageView.isUserInteractionEnabled = true
            handSlotImageView.tag = Int(index)
            handSlotImageView.image = dataSource?.imageForTile(at: index)
            handSlotImageView.addGestureRecognizer(tapRecognizer)
            
            self.addSubview(handSlotImageView)
        }
    }
    
    func slotImageTapped(_ sender: UITapGestureRecognizer) {
        if let handSlotView = sender.view {
            self.delegate?.handViewSlotWasTapped(at: handSlotView.tag)
        }
    }

}
