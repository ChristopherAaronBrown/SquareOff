//
//  Path.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

struct Path {
    fileprivate let coordinates: [Coordinate]
    private let movementCardType: MovementCard.Type
    
    var count: Int {
        return coordinates.count
    }
    
    var description: String {
        var result = ""
        for index in 0..<coordinates.count {
            let coordinate = coordinates[index]
            if index == coordinates.count - 1 {
                result += "\(coordinate.description)"
            } else {
                result += "\(coordinate.description),"
            }
        }
        return result
    }
    
    var beginning: Coordinate {
        return coordinates.first!
    }
    
    var end: Coordinate {
        return coordinates.last!
    }
    
    init(coordinates: [Coordinate], movementCardType: MovementCard.Type) {
        self.coordinates = coordinates
        self.movementCardType = movementCardType
    }
    
    func closest(coordinate: Coordinate) -> Coordinate {
        for index in 1..<coordinates.count {
            if coordinates[index] == coordinate {
                return coordinates[index - 1]
            }
        }
        return coordinate
    }
    
    func contains(coordinate: Coordinate) -> Bool {
        for boardCoordinate in coordinates {
            if coordinate == boardCoordinate {
                return true
            }
        }
        return false
    }
    
    func requiredMovementCardType() -> Card.Type {
        return movementCardType as! Card.Type
    }
}

extension Path: Sequence {
    func makeIterator() -> AnyIterator<Coordinate> {
        return AnyIterator(self.coordinates.makeIterator())
    }
}

enum PathAction {
    
    case None
    case Move
    case Jump
    case Attack
    case JumpAndAttack
    case JumpOrAttack
    
    func canPerform(with hand: Hand) -> (Bool, [Card.Type]) {
        var tileTypes: [Card.Type] = []
        switch self {
        case .None:
            return (false, tileTypes)
        case .Move:
            return (true, tileTypes)
        case .Jump:
            return (PathAction.contains(type: JumpCard.self, in: hand, with: &tileTypes), tileTypes)
        case .Attack:
            return (PathAction.contains(type: AttackCard.self, in: hand, with: &tileTypes), tileTypes)
        case .JumpAndAttack:
            let canPerform = PathAction.contains(type: JumpCard.self, in: hand, with: &tileTypes) &&
                PathAction.contains(type: AttackCard.self, in: hand, with: &tileTypes)
            return (canPerform, tileTypes)
        case .JumpOrAttack:
            let canPerform = PathAction.contains(type: JumpCard.self, in: hand, with: &tileTypes) ||
                PathAction.contains(type: AttackCard.self, in: hand, with: &tileTypes)
            return (canPerform, tileTypes)
        }
    }
    
    private static func contains(type: Card.Type, in hand: Hand, with tileTypes: inout [Card.Type]) -> Bool {
        if hand.cards.contains(where: { (card) -> Bool in type(of: card) == type }) {
            tileTypes.append(type)
            return true
        } else {
            tileTypes.removeAll()
            return false
        }
    }
}
