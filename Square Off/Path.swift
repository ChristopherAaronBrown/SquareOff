//
//  Path.swift
//  Square Off
//
//  Created by Chris Brown on 2/9/17.
//  Copyright © 2016 Chris Brown. All rights reserved.
//

struct Path {
    fileprivate let coordinates: [BoardCoordinate]
    private let movementTileType: MovementTile.Type
    
    var count: Int {
        return coordinates.count
    }
    
    var beginning: BoardCoordinate {
        return coordinates.first!
    }
    
    var end: BoardCoordinate {
        return coordinates.last!
    }
    
    init(coordinates: [BoardCoordinate], movementTileType: MovementTile.Type) {
        self.coordinates = coordinates
        self.movementTileType = movementTileType
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
    
    func requiredMovementTileType() -> Tile.Type {
        return movementTileType as! Tile.Type
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
        case .JumpAndAttack:
            let canPerform = PathAction.contains(type: JumpTile.self, in: hand, with: &tileTypes) &&
                PathAction.contains(type: AttackTile.self, in: hand, with: &tileTypes)
            return (canPerform, tileTypes)
        case .JumpOrAttack:
            let canPerform = PathAction.contains(type: JumpTile.self, in: hand, with: &tileTypes) ||
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
