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
    @IBOutlet weak var removeAdsButton: UIButton!
    @IBOutlet weak var restorePurchaseButton: UIButton!
    
    override func viewDidLoad() {
        
        // TODO: Unhide buttons in Main.storyboard
        removeAdsButton.isEnabled = false
        restorePurchaseButton.isEnabled = false
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameVC {
            destination.player1Name = firstPlayer.text!.isEmpty ? "Player 1" : firstPlayer.text
            destination.player2Name = secondPlayer.text!.isEmpty ? "Player 2" : secondPlayer.text
        }
    }
    
    @IBAction func removeAdsPressed(_ sender: UIButton) {
    }
    
    @IBAction func restorePurchasePressed(_ sender: UIButton) {
    }
    
    private func removeAds() {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstPlayer {
            secondPlayer.becomeFirstResponder()
        } else {
            secondPlayer.resignFirstResponder()
        }
        return true
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}
