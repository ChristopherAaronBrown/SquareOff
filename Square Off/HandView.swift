//
//  HandView.swift
//  Square Off
//
//  Created by Chris Brown on 8/22/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

protocol HandViewDataSource {
    func numberOfTiles() -> UInt
    func imageForTile(index: UInt) -> UIImage?
}

protocol HandViewDelegate {
    func handViewSlotWasTapped(index: UInt)
}

class HandView: UIView {
    var dataSource: HandViewDataSource?
    var delegate: HandViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let numTiles: UInt = dataSource?.numberOfTiles() ?? 0
        let handSlotDimension: CGFloat = (self.bounds.size.width - ((10 * CGFloat(numTiles)) + 10)) / CGFloat(numTiles)
        
        for i: UInt in 0..<numTiles {
            let xPos: CGFloat = (handSlotDimension + 10) * CGFloat(i) + 10
            let yPos: CGFloat = 0
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(HandView.slotImageTapped))
            let handSlotView = UIImageView(frame: CGRectMake(xPos, yPos, handSlotDimension, handSlotDimension))
            
            handSlotView.userInteractionEnabled = true
            handSlotView.tag = Int(i)
            handSlotView.image = dataSource?.imageForTile(i)
            handSlotView.addGestureRecognizer(tapRecognizer)
            
            self.addSubview(handSlotView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func slotImageTapped(sender: UITapGestureRecognizer) {
        if let handSlotView = sender.view {
            self.delegate?.handViewSlotWasTapped(UInt(handSlotView.tag))
        }
    }
}