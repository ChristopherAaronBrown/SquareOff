//
//  PathOptionVC.swift
//  Square Off
//
//  Created by Chris Brown on 2/27/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

protocol PathOptionVCDataSource {
    func currentPlayer() -> Player
    func pathActionChoices() -> [PathAction]
    func movementCard() -> MovementCard.Type
}

protocol PathOptionVCDelegate {
    func chosenAction(action: PathAction)
}

class PathOptionVC: UIViewController {
    
    var dataSource: PathOptionVCDataSource!
    var delegate: PathOptionVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePopup()
        showAnimate()
    }
    
    private func configurePopup() {
        addBackground()
        addPopup()
        addChoices()
    }
    
    private func addBackground() {
        let backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = UIColor.white
        backgroundView.alpha = 0.3
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAnimate))
        backgroundView.addGestureRecognizer(tapRecognizer)
        
        view.addSubview(backgroundView)
    }
    
    private func addPopup() {
        let numOptions: CGFloat = CGFloat(dataSource.pathActionChoices().count)
        let width: CGFloat = view.bounds.width * (274/320)
        let height: CGFloat = view.bounds.height * ((48 + numOptions * 88)/568)
        let xPos: CGFloat = view.bounds.midX - width / 2
        let yPos: CGFloat = view.bounds.midY - height / 2
        let frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        let popupView = UIView(frame: frame)
        
        popupView.backgroundColor = Colors.offWhite
        popupView.layer.cornerRadius = 8
        popupView.layer.shadowColor = Colors.font.cgColor
        popupView.layer.shadowOpacity = 0.7
        popupView.layer.shadowOffset = CGSize(width: 0, height: 8)
        popupView.layer.shadowRadius = 10
        
        view.addSubview(popupView)
    }
    
    private func addChoices() {
        let currentPlayer = dataSource.currentPlayer()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedChoice(_:)))
        let width: CGFloat = view.bounds.width * (66/320)
        let height: CGFloat = view.bounds.height * (72/568)
        var xPos: CGFloat = view.bounds.midX - width / 2
        var yPos: CGFloat = 0
        
        var tileNum: CGFloat = 1
        
        print(dataSource.pathActionChoices())
        
        // Movement Card
        yPos += (height + (16/528)) * tileNum
        
        tileNum += 1
        
        // Attack Card
        if dataSource.pathActionChoices().contains(PathAction.Attack) {
            yPos += (height + (16/528)) * tileNum
            
            let frame: CGRect = CGRect(x: xPos, y: yPos, width: width, height: height)
            let tileImageView = UIImageView(frame: frame)
            tileImageView.image = currentPlayer.number == 0 ? #imageLiteral(resourceName: "AttackPink") : #imageLiteral(resourceName: "AttackGreen")
            tileImageView.isUserInteractionEnabled = true
            tileImageView.addGestureRecognizer(tapRecognizer)
            tileImageView.tag = 1
            
            view.addSubview(tileImageView)
            
            tileNum += 1
        }
        
        // Jump Card
        if dataSource.pathActionChoices().contains(PathAction.Jump) {
            yPos += (height + (16/528)) * tileNum
            
            let frame: CGRect = CGRect(x: xPos, y: yPos, width: width, height: height)
            let tileImageView = UIImageView(frame: frame)
            tileImageView.image = currentPlayer.number == 0 ? #imageLiteral(resourceName: "JumpPink") : #imageLiteral(resourceName: "JumpGreen")
            tileImageView.isUserInteractionEnabled = true
            tileImageView.addGestureRecognizer(tapRecognizer)
            tileImageView.tag = 2
            
            view.addSubview(tileImageView)
            
            tileNum += 1
        }
        
        // Jump + Attack Card
        if dataSource.pathActionChoices().contains(PathAction.JumpAndAttack) {
            yPos += (height + (16/528)) * tileNum
            
            // Jump
            xPos = view.bounds.midX - width
            let jumpFrame: CGRect = CGRect(x: xPos, y: yPos, width: width, height: height)
            let jumpCardImageView = UIImageView(frame: jumpFrame)
            jumpCardImageView.image = currentPlayer.number == 0 ? #imageLiteral(resourceName: "JumpPink") : #imageLiteral(resourceName: "JumpGreen")
            jumpCardImageView.isUserInteractionEnabled = true
            jumpCardImageView.addGestureRecognizer(tapRecognizer)
            jumpCardImageView.tag = 3
            
            view.addSubview(jumpCardImageView)
            
            // Attack
            xPos = view.bounds.midX + width
            let attackFrame: CGRect = CGRect(x: xPos, y: yPos, width: width, height: height)
            let attackCardImageView = UIImageView(frame: attackFrame)
            attackCardImageView.image = currentPlayer.number == 0 ? #imageLiteral(resourceName: "AttackPink") : #imageLiteral(resourceName: "AttackGreen")
            attackCardImageView.isUserInteractionEnabled = true
            attackCardImageView.addGestureRecognizer(tapRecognizer)
            attackCardImageView.tag = 4
            
            view.addSubview(attackCardImageView)
            
            tileNum += 1
        }
        
        tileNum = 1
    }
    
    @objc private func tappedChoice(_ sender: UITapGestureRecognizer) {
        if let tileImageView = sender.view as? UIImageView {
            switch tileImageView.tag {
            case 1:
                delegate.chosenAction(action: .Attack)
            case 2:
                delegate.chosenAction(action: .Jump)
            case 3, 4:
                delegate.chosenAction(action: .JumpAndAttack)
            default:
                delegate.chosenAction(action: .Move)
            }
        }
        dismissAnimate()
    }
    
    
    private func showAnimate() {
        view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        view.alpha = 0
        UIView.animate(withDuration: 0.25) {
//            self.view.center = destination
            self.view.alpha = 1
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func dismissAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
//            self.view.center = destination
            self.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            self.view.alpha = 0
        }) { (finished) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }
    
}
