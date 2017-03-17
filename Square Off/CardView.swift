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
        layer.shadowColor = Colors.font.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 1.5
        
        topColor = player.number == 0 ? Colors.player1Light : Colors.player2Light
        bottomColor = player.number == 0 ? Colors.player1Dark : Colors.player2Dark
        
        let iconImageView = UIImageView(image: icon)
        iconImageView.center = bounds.center
        
        addSubview(iconImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
