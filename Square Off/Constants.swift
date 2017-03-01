//
//  Constants.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

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
}

enum Gem: Int {
    case Single = 1
    case Double = 2
    case Triple = 3
}

enum ShopTile: Int {
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
    case ResurrectTileTapped
}
