//
//  Tile.swift
//  Tiles2048
//
//  Created by zhimoe on 2023/5/27.
//

import Foundation

typealias IndexPair = (Int, Int)

protocol Tile: Identifiable, Equatable {
    
    associatedtype Value
    
    var value: Value { get set }
}

struct IdentifiedTile: Tile {
    var id: Int
    var value: Int
}

struct IndexedTile<T: Tile> {
    
    typealias Index = IndexPair
    
    let index: Index
    let tile: T
}

