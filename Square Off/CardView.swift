//
//  CardView.swift
//  Square Off
//
//  Created by Chris Brown on 3/6/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

protocol CardViewDataSource {
    func lightColor() -> CGColor
    func darkColor() -> CGColor
    func cardIcon() -> UIImage
}

class CardView: UIView {

    var dataSource: CardViewDataSource!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generate() {
        // Background Rect
        let card = CAGradientLayer()
        card.frame = frame
        card.colors = [dataSource.lightColor(), dataSource.darkColor()]
        card.cornerRadius = 4
        
        layer.insertSublayer(card, at: 0)
        
        let icon = UIImageView(image: dataSource.cardIcon())
        
        addSubview(icon)
    }

}
