//
//  WinnerVC.swift
//  Square Off
//
//  Created by Chris Brown on 4/10/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

class WinnerVC: UIViewController {

    @IBOutlet weak var winner: UILabel!
    
    var playerName: String!
    
    override func viewDidLoad() {
        winner.text = playerName
    }
    
    @IBAction func mainMenuPressed(_ sender: UIButton) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
