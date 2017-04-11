//
//  MenuVC.swift
//  Square Off
//
//  Created by Chris Brown on 2/10/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstPlayer: UITextField!
    @IBOutlet weak var secondPlayer: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameVC {
            destination.player1Name = firstPlayer.text ?? "Player 1"
            destination.player2Name = secondPlayer.text ?? "Player 2"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstPlayer {
            secondPlayer.becomeFirstResponder()
        } else {
            secondPlayer.resignFirstResponder()
        }
        return true
    }
}
