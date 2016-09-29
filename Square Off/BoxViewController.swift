//
//  BoxViewController.swift
//  Square Off
//
//  Created by Chris Brown on 9/2/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

class BoxViewController: UIViewController, BoxViewDataSource, BoxViewDelegate {

    var totalGems: Int
    let colors: ColorPairings
    var currentPlayer: Player
    var boxView: BoxView?
    var dismissButton: UIButton?
    
    init(totalGems: Int, colors: ColorPairings, currentPlayer: Player) {
        self.totalGems = totalGems
        self.colors = colors
        self.currentPlayer = currentPlayer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func exit() {
        if dismissButton?.titleLabel?.text == "PURCHASE" {
            purchaseTile()
            removeGems()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func purchaseTile() {
        var tile: Tile?
        
        // TODO: Find better way of doing this
        for view in (boxView?.subviews)! {
            if view.tintColor == playerColor() {
                switch view.tag {
                case 0:
                    tile = GemTile(value: 1)
                case 1:
                    tile = GemTile(value: 2)
                case 2:
                    tile = GemTile(value: 3)
                case 3:
                    tile = JumpTile()
                case 4:
                    tile = AttackTile()
                case 5:
                    tile = DefendTile()
                case 6:
                    tile = GemTile(value: 1)
                case 7:
                    tile = GemTile(value: 1)
                case 8:
                    tile = GemTile(value: 1)
                case 9:
                    tile = GemTile(value: 1)
                case 10:
                    tile = GemTile(value: 1)
                case 11:
                    tile = GemTile(value: 1)
                case 12:
                    tile = GemTile(value: 1)
                case 13:
                    tile = GemTile(value: 1)
                case 14:
                    tile = GemTile(value: 1)
                case 15:
                    tile = GemTile(value: 1)
                default:
                    tile = BurnTile()
                }
            }
        }
        
        currentPlayer.playerDiscard.add(tile!)
    }
    
    func removeGems() {
        for tile in currentPlayer.playerHand {
            if tile is GemTile {
                let targetIndex = currentPlayer.playerHand.tiles.index(of: tile)!
                currentPlayer.playerHand.removeTile(at: targetIndex, for: currentPlayer)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let boxViewXPos: CGFloat = 0
        let boxViewYPos: CGFloat = UIApplication.shared.statusBarFrame.height + 20
        let boxWidth: CGFloat = self.view.bounds.width
        let boxHeight: CGFloat = self.view.bounds.height - boxViewYPos - (self.view.bounds.width / 6) - 50
        boxView = BoxView(frame: CGRect(x: boxViewXPos, y: boxViewYPos, width: boxWidth, height: boxHeight))
        
        boxView!.dataSource = self
        boxView!.delegate = self
        
        self.view.addSubview(boxView!)
        
        let dismissWidth: CGFloat = self.view.bounds.width * (2/3)
        let dismissHeight: CGFloat = 50
        let dismissXPos: CGFloat = self.view.bounds.width / 6
        let dismissYPos: CGFloat = self.view.bounds.height - (dismissHeight / 2) - dismissXPos
        dismissButton = UIButton(frame: CGRect(x: dismissXPos, y: dismissYPos, width: dismissWidth, height: dismissHeight))
        dismissButton!.setTitle("CANCEL", for: UIControlState())
        dismissButton!.titleLabel!.font = UIFont(name: "Anita-semi-square", size: 20)
        dismissButton!.backgroundColor = colors.neutralColor
        dismissButton!.addTarget(self, action: #selector(exit), for: UIControlEvents.touchUpInside)
        dismissButton!.layer.cornerRadius = 5
        self.view.addSubview(dismissButton!)
    }
    
    // MARK: - BoxViewDataSource
    func totalGemsInHand() -> Int {
        return self.totalGems
    }
    
    func playerColor() -> UIColor {
        return currentPlayer.number == 0 ? colors.player1Color : colors.player2Color
    }
    
    // MARK: BoxViewDelegate
    func tileTapped(at index: Int) {
        
        // TODO: Change cost label color with tap
        for view in (boxView?.subviews)! {
            if view.tintColor != UIColor.lightGray {
                if view.tag == index {
                    view.tintColor = colors.neutralColor
                } else {
                    view.tintColor = playerColor()
                }
            }
        }
        boxView?.viewWithTag(index)?.tintColor = colors.neutralColor
        dismissButton!.setTitle("PURCHASE", for: UIControlState())
    }
}
