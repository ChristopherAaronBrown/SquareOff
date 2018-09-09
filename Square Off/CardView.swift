//
//  CardView.swift
//  Square Off
//
//  Created by Chris Brown on 3/6/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

class CardView: GradientView {

    init(frame: CGRect, player: Player, icon: UIImage) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        layer.cornerRadius = 4
        layer.shadowColor = Color.font.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 1.5
        
        topColor = player.number == 0 ? Color.player1Light : Color.player2Light
        bottomColor = player.number == 0 ? Color.player1Dark : Color.player2Dark
        
        let iconWidth: CGFloat = bounds.width * (38/50)
        let iconHeight: CGFloat = bounds.height * (28/70)
        let iconOffset: CGFloat = frame.midX - iconWidth / 2
        let iconFrame = CGRect(x: iconOffset, y: iconOffset, width: iconWidth, height: iconHeight)
        let iconImageView = UIImageView(frame: iconFrame)
        iconImageView.image = icon
        iconImageView.center = bounds.center
        
        addSubview(iconImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
