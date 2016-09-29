//
//  HandView.swift
//  Square Off
//
//  Created by Chris Brown on 8/22/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

protocol HandViewDataSource {
    func numberOfTiles() -> Int
    func imageForTile(at index: Int) -> UIImage?
    func tintForTile(at index: Int) -> UIColor
}

protocol HandViewDelegate {
    func handViewSlotWasTapped(at index: Int)
}

class HandView: UIView {
    var dataSource: HandViewDataSource?
    var delegate: HandViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Remove previous hand
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let numTiles: Int = dataSource?.numberOfTiles() ?? 0
        let handSlotSize: CGFloat = (self.bounds.size.width - 60) / 5
        
        for i in 0..<numTiles {
            let padding: CGFloat = ((self.bounds.size.width - (CGFloat(numTiles) * handSlotSize)) / (CGFloat(numTiles) + 1))
            let xPos: CGFloat = (handSlotSize + padding) * CGFloat(i) + padding
            let yPos: CGFloat = 0
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(HandView.slotImageTapped))
            let handSlotImageView = UIImageView(frame: CGRect(x: xPos, y: yPos, width: handSlotSize, height: handSlotSize))
            
            handSlotImageView.isUserInteractionEnabled = true
            handSlotImageView.tag = Int(i)
            handSlotImageView.image = dataSource?.imageForTile(at: i)
            handSlotImageView.addGestureRecognizer(tapRecognizer)
            handSlotImageView.image = handSlotImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            handSlotImageView.tintColor = dataSource?.tintForTile(at: i)
            
            self.addSubview(handSlotImageView)
        }
    }
    
    func slotImageTapped(_ sender: UITapGestureRecognizer) {
        if let handSlotView = sender.view {
            self.delegate?.handViewSlotWasTapped(at: handSlotView.tag)
        }
    }
}
