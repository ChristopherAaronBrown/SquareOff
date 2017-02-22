//
//  Path.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

struct Path {
    let coordinates: [BoardCoordinate]
    
    init(coordinates: [BoardCoordinate]) {
        self.coordinates = coordinates
    }
    
    func end() -> BoardCoordinate {
        return coordinates[coordinates.count - 1]
    }
    
    func beginning() -> BoardCoordinate {
        return coordinates[0]
    }
    
    func count() -> Int {
        return coordinates.count
    }
    
    func containsCoordinate(_ coordinate: BoardCoordinate) -> Bool {
        for boardCoordinate in coordinates {
            if coordinate == boardCoordinate {
                return true
            }
        }
        return false
    }
}

extension Path: Sequence {
    func makeIterator() -> AnyIterator<BoardCoordinate> {
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
//    case moveOrAttack
//    case moveOrJump

//    func requiredTiles() -> [Tile.Type] {
//        switch self {
//        case .None:
//            return []
//        case .Move:
//            return []
//        case .Jump:
//            return [JumpTile.self]
//        case .Attack:
//            return [AttackTile.self]
//        case .JumpAndAttack:
//            return [JumpTile.self,AttackTile.self]
//        case .JumpOrAttack:
//            return [JumpTile.self,AttackTile.self]
//        }
//    }
    func canPerform(with hand: PlayerHand) -> (Bool, [Tile.Type]) {
        var tileTypes: [Tile.Type] = []
        switch self {
        case .None:
            return (false, tileTypes)
        case .Move:
            return (true, tileTypes)
        case .Jump:
            return (PathAction.contains(type: JumpTile.self, in: hand, with: &tileTypes), tileTypes)
        case .Attack:
            return (PathAction.contains(type: AttackTile.self, in: hand, with: &tileTypes), tileTypes)
        case .JumpAndAttack, .JumpOrAttack:
            let canPerform = PathAction.contains(type: JumpTile.self, in: hand, with: &tileTypes) &&
                PathAction.contains(type: AttackTile.self, in: hand, with: &tileTypes)
            return (canPerform, tileTypes)
        }
    }
    
    private static func contains(type: Tile.Type, in hand: PlayerHand, with tileTypes: inout [Tile.Type]) -> Bool {
        if hand.tiles.contains(where: { (tile) -> Bool in type(of: tile) == type }) {
            tileTypes.append(type)
            return true
        } else {
            tileTypes.removeAll()
            return false
        }
    }
}
