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

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let colors = ColorPairings.init()
        
        let player1 = Player(playerNum: 0, playerName: "Chris", color: colors.player1Color)
        let player2 = Player(playerNum: 1, playerName: "Greg", color: colors.player2Color)
        let board = GameBoard(player1: player1, player2: player2, colors: colors)
        let session = GameSession(player1: player1, player2: player2, board: board, colors: colors)
        
        window?.rootViewController = GameSpaceViewController(session: session)
        window?.makeKeyAndVisible()
        
        return true
    }
}

struct ColorPairings {
    var player1Color: UIColor!
    var player2Color: UIColor!
    var neutralColor: UIColor!
    
    init() {
        let set = arc4random_uniform(15)
        
        switch set {
        case 0:
            // Blue vs Lime
            player1Color = UIColor.init(netHex: 0x1C0E8D)
            player2Color = UIColor.init(netHex: 0x80A30D)
            neutralColor = UIColor.init(netHex: 0xFD6915)
        case 1:
            // Green vs Purple
            player1Color = UIColor.init(netHex: 0x678613)
            player2Color = UIColor.init(netHex: 0x590077)
            neutralColor = UIColor.init(netHex: 0x16777E)
        case 2:
            // Light Blue vs Orange
            player1Color = UIColor.init(netHex: 0x1E74FE)
            player2Color = UIColor.init(netHex: 0xE03E0B)
            neutralColor = UIColor.init(netHex: 0xECF75B)
        case 3:
            // Light Blue vs Yellow
            player1Color = UIColor.init(netHex: 0x0C67D3)
            player2Color = UIColor.init(netHex: 0xD9930B)
            neutralColor = UIColor.init(netHex: 0xC30066)
        case 4:
            // Blue vs Orange
            player1Color = UIColor.init(netHex: 0x2200A6)
            player2Color = UIColor.init(netHex: 0xF44B06)
            neutralColor = UIColor.init(netHex: 0xFDFF09)
        case 5:
            // Pink vs Blue
            player1Color = UIColor.init(netHex: 0xBB1E46)
            player2Color = UIColor.init(netHex: 0x106F75)
            neutralColor = UIColor.init(netHex: 0x74004A)
        case 6:
            // Pink vs Green
            player1Color = UIColor.init(netHex: 0xBA2566)
            player2Color = UIColor.init(netHex: 0x358F2D)
            neutralColor = UIColor.init(netHex: 0x2BD5E8)
        case 7:
            // Pink vs Orange
            player1Color = UIColor.init(netHex: 0xCF1C6E)
            player2Color = UIColor.init(netHex: 0xE6810D)
            neutralColor = UIColor.init(netHex: 0x9359FF)
        case 8:
            // Turquoise vs Orange
            player1Color = UIColor.init(netHex: 0x1D726A)
            player2Color = UIColor.init(netHex: 0xD54E16)
            neutralColor = UIColor.init(netHex: 0x9C640F)
        case 9:
            // Dark Blue vs Yellow
            player1Color = UIColor.init(netHex: 0x0C104B)
            player2Color = UIColor.init(netHex: 0xAA6B15)
            neutralColor = UIColor.init(netHex: 0xFB402B)
        case 10:
            // Green vs Magenta
            player1Color = UIColor.init(netHex: 0x68AC1E)
            player2Color = UIColor.init(netHex: 0x921472)
            neutralColor = UIColor.init(netHex: 0xE7BB0D)
        case 11:
            // Green vs Orange
            player1Color = UIColor.init(netHex: 0x29845E)
            player2Color = UIColor.init(netHex: 0xAF2B1C)
            neutralColor = UIColor.init(netHex: 0xA96CE8)
        case 12:
            // Light Green vs Blue
            player1Color = UIColor.init(netHex: 0x76E167)
            player2Color = UIColor.init(netHex: 0x2E3FD6)
            neutralColor = UIColor.init(netHex: 0xFD931F)
        case 13:
            // Lumigreen vs Purple
            player1Color = UIColor.init(netHex: 0x509F34)
            player2Color = UIColor.init(netHex: 0x75006C)
            neutralColor = UIColor.init(netHex: 0xFDA709)
        case 14:
            // Soda vs Purple
            player1Color = UIColor.init(netHex: 0x55AA86)
            player2Color = UIColor.init(netHex: 0x831BA3)
            neutralColor = UIColor.init(netHex: 0x7ECB18)
        case 15:
            // Yellow vs Lilac
            player1Color = UIColor.init(netHex: 0xD37D13)
            player2Color = UIColor.init(netHex: 0x3B0D91)
            neutralColor = UIColor.init(netHex: 0x92E784)
        default:
            break
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
