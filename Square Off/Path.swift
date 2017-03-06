//
//  Path.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

struct Path {
    fileprivate let coordinates: [BoardCoordinate]
    private let movementCardType: MovementCard.Type
    
    var count: Int {
        return coordinates.count
    }
    
    var beginning: BoardCoordinate {
        return coordinates.first!
    }
    
    var end: BoardCoordinate {
        return coordinates.last!
    }
    
    init(coordinates: [BoardCoordinate], movementCardType: MovementCard.Type) {
        self.coordinates = coordinates
        self.movementCardType = movementCardType
    }
    
    func closest(coordinate: BoardCoordinate) -> BoardCoordinate {
        for index in 1..<coordinates.count {
            if coordinates[index] == coordinate {
                return coordinates[index - 1]
            }
        }
        return coordinate
    }
    
    func contains(coordinate: BoardCoordinate) -> Bool {
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
    func makeIterator() -> AnyIterator<BoardCoordinate> {
        return AnyIterator(self.coordinates.makeIterator())
    }
}

enum PathAction {
    // TODO: Remove None, JumpAndAttack, JumpOrAttack and replace with PlayOptions
    case None
    case Move
    case Jump
    case Attack
    case JumpAndAttack
    case JumpOrAttack
//    case moveOrAttack
//    case moveOrJump

//    func requiredCards() -> [Card.Type] {
//        switch self {
//        case .None:
//            return []
//        case .Move:
//            return []
//        case .Jump:
//            return [JumpCard.self]
//        case .Attack:
//            return [AttackCard.self]
//        case .JumpAndAttack:
//            return [JumpCard.self,AttackCard.self]
//        case .JumpOrAttack:
//            return [JumpCard.self,AttackCard.self]
//        }
//    }
    func canPerform(with hand: PlayerHand) -> (Bool, [Card.Type]) {
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
    
    private static func contains(type: Card.Type, in hand: PlayerHand, with tileTypes: inout [Card.Type]) -> Bool {
        if hand.tiles.contains(where: { (card) -> Bool in type(of: card) == type }) {
            tileTypes.append(type)
            return true
        } else {
            tileTypes.removeAll()
            return false
        }
    }
}
