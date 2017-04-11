//
//  PlayOptionCell.swift
//  Square Off
//
//  Created by Chris Brown on 3/21/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

class PlayOptionCell: UITableViewCell {

    func configure(_ playOption: PlayOption) {
        for cardType in playOption.requiredCards {
            print("Card Type: \(cardType)")
        }
        
        textLabel?.text = "\(playOption.action)"
    }
    

}
