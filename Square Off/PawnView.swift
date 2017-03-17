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
        generate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generate() {
        backgroundColor = .clear
        
        // Side of pawn
        let sideRect = UIView(frame: bounds)
        sideRect.backgroundColor = darkColor
        sideRect.layer.cornerRadius = 8
        
        // Top of pawn
        let topRectFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * (44/48))
        let topRect = UIView(frame: topRectFrame)
        topRect.backgroundColor = lightColor
        topRect.layer.cornerRadius = 8
        
        addSubview(sideRect)
        addSubview(topRect)
    }
}
