//
//  PawnImageView.swift
//  Square Off
//
//  Created by Chris Brown on 3/15/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

class PawnView: UIView {
    
    private let owner: Player
    private var lightColor: UIColor {
        return owner.number == 0 ? Colors.player1Light : Colors.player2Light
    }
    private var darkColor: UIColor {
        return owner.number == 0 ? Colors.player1Dark : Colors.player2Dark
    }
    
    init(frame: CGRect, owner: Player) {
        self.owner = owner
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // Side of pawn
        let sideView = UIView(frame: bounds)
        sideView.backgroundColor = darkColor
        sideView.layer.cornerRadius = 8
        
        // Top of pawn
        let faceFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * (44/48))
        let faceView = UIView(frame: faceFrame)
        faceView.backgroundColor = lightColor
        faceView.layer.cornerRadius = 8
        
        // Pawn icon
        let iconLength: CGFloat = bounds.width * (28.67/44)
        let iconOffset: CGFloat = faceView.frame.midX - iconLength / 2
        let iconFrame = CGRect(x: iconOffset, y: iconOffset, width: iconLength, height: iconLength)
        let iconImage = owner.number == 0 ? #imageLiteral(resourceName: "PawnPlayer1") : #imageLiteral(resourceName: "PawnPlayer2")
        let iconImageView = UIImageView(frame: iconFrame)
        iconImageView.image = iconImage
        
        addSubview(sideView)
        addSubview(faceView)
        addSubview(iconImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
