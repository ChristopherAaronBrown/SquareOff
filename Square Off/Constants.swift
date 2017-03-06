//
//  Constants.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import Foundation
import UIKit

typealias AnimationCallback = (Bool) -> ()

struct Constants {
    
    static let numberOfBoardSpaces: Int = 6
    static let handLimit: Int = 5
    
}

struct Colors {
    static let green: UIColor = UIColor(red: 114/255, green: 237/255, blue: 149/255, alpha: 1)
    static let greenShadow: UIColor = UIColor(red: 106/255, green: 191/255, blue: 88/255, alpha: 1)
    static let pink: UIColor = UIColor(red: 255/255, green: 100/255, blue: 126/255, alpha: 1)
    static let pinkShadow: UIColor = UIColor(red: 206/255, green: 80/255, blue: 122/255, alpha: 1)
    static let neutral: UIColor = UIColor(red: 206/255, green: 230/255, blue: 223/255, alpha: 1)
    static let neutralShadow: UIColor = UIColor(red: 185/255, green: 217/255, blue: 217/255, alpha: 1)
    static let offWhite: UIColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
    static let font: UIColor = UIColor(red: 119/255, green: 126/255, blue: 141/255, alpha: 1)
    static let blue: UIColor = UIColor(red: 97/255, green: 203/255, blue: 255/255, alpha: 1)
    static let blueShadow: UIColor = UIColor(red: 91/255, green: 167/255, blue: 244/255, alpha: 1)
    static let yellow: UIColor = UIColor(red: 255/255, green: 205/255, blue: 93/255, alpha: 1)
    
    static var player1Light: UIColor {
        get {
            switch ColorPairings(rawValue: UserDefaults.standard.integer(forKey: "ColorPairing"))! {
            case .GreenVsPink:
                return UIColor(red: 160/255, green: 214/255, blue: 116/255, alpha: 1)
            case .YellowVsBlue:
                return UIColor(red: 249/255, green: 192/255, blue: 86/255, alpha: 1)
            case .OrangeVsTeal:
                return UIColor(red: 233/255, green: 87/255, blue: 14/255, alpha: 1)
            case .BlueVsPurple:
                return UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 1)
            }
        }
    }
    static var player1Dark: UIColor {
        get {
            switch ColorPairings(rawValue: UserDefaults.standard.integer(forKey: "ColorPairing"))! {
            case .GreenVsPink:
                return UIColor(red: 114/255, green: 162/255, blue: 75/255, alpha: 1)
            case .YellowVsBlue:
                return UIColor(red: 221/255, green: 170/255, blue: 75/255, alpha: 1)
            case .OrangeVsTeal:
                return UIColor(red: 169/255, green: 82/255, blue: 46/255, alpha: 1)
            case .BlueVsPurple:
                return UIColor(red: 0/255, green: 91/255, blue: 156/255, alpha: 1)
            }
        }
    }
    static var player2Light: UIColor {
        get {
            switch ColorPairings(rawValue: UserDefaults.standard.integer(forKey: "ColorPairing"))! {
            case .GreenVsPink:
                return UIColor(red: 240/255, green: 79/255, blue: 110/255, alpha: 1)
            case .YellowVsBlue:
                return UIColor(red: 94/255, green: 185/255, blue: 233/255, alpha: 1)
            case .OrangeVsTeal:
                return UIColor(red: 153/255, green: 213/255, blue: 222/255, alpha: 1)
            case .BlueVsPurple:
                return UIColor(red: 143/255, green: 89/255, blue: 175/255, alpha: 1)
            }
        }
    }
    static var player2Dark: UIColor {
        get {
            switch ColorPairings(rawValue: UserDefaults.standard.integer(forKey: "ColorPairing"))! {
            case .GreenVsPink:
                return UIColor(red: 187/255, green: 52/255, blue: 78/255, alpha: 1)
            case .YellowVsBlue:
                return UIColor(red: 81/255, green: 155/255, blue: 195/255, alpha: 1)
            case .OrangeVsTeal:
                return UIColor(red: 117/255, green: 181/255, blue: 190/255, alpha: 1)
            case .BlueVsPurple:
                return UIColor(red: 93/255, green: 51/255, blue: 119/255, alpha: 1)
            }
        }
    }
}

enum ColorPairings: Int {
    case GreenVsPink = 0
    case YellowVsBlue = 1
    case OrangeVsTeal = 2
    case BlueVsPurple = 3
}

enum Gem: Int {
    case Single = 1
    case Double = 2
    case Triple = 3
}

enum ShopCard: Int {
    case SingleGem = 0
    case DoubleGem = 1
    case TripleGem = 2
    case Jump = 3
    case Attack = 4
    case Defend = 5
    case Burn = 6
    case Resurrect = 7
    case SingleStraight = 8
    case SingleDiagonal = 9
    case ZigZagLeft = 10
    case KnightLeft = 11
    case DoubleStraight = 12
    case DoubleDiagonal = 13
    case ZigZagRight = 14
    case KnightRight = 15
}

enum State {
    case Normal
    case ResurrectCardTapped
}
