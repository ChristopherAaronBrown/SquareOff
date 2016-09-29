//
//  PurchaseTileView.swift
//  Square Off
//
//  Created by Chris Brown on 9/2/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

protocol PurchaseTileDataSource {
    func tileImage() -> UIImage?
    func tileCost() -> Int
    func totalGemsInHand() -> Int
}

class PurchaseTileView: UIView {

    var dataSource: PurchaseTileDataSource?
    
    override func layoutSubviews() {
        let imageWidth: CGFloat = self.bounds.width
        let imageHeight: CGFloat = self.bounds.height - 10
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        let costLabel = UILabel(frame: CGRect(x: 0, y: imageHeight, width: imageWidth, height: 10))
        
        imageView.image = dataSource?.tileImage()
        costLabel.text = "Cost: \(dataSource?.tileCost())"
        costLabel.textAlignment = .center
        costLabel.font = UIFont(name: "Anita-semi-square", size: 20)
        
        self.addSubview(imageView)
        self.addSubview(costLabel)
    }

}
