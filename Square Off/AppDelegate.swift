//
//  AppDelegate.swift
//  Square Off
//
//  Created by Chris Brown on 8/5/16.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let player1 = Player(playerNum: 0, playerName: "Chris")
        let player2 = Player(playerNum: 1, playerName: "Greg")
        let gameBoard = GameBoard()
        let gameSession = GameSession(player1: player1, player2: player2, board: gameBoard)
        
        window?.rootViewController = GameSpaceViewController(gameSession: gameSession)
        window?.makeKeyAndVisible()
        
        return true
    }
}