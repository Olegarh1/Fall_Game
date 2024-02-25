//
//  PhysicsCategory.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 23.02.2024.
//

import Foundation

struct PhysicsCategory {
    static let Player:      UInt32 = 0b1
    static let Wall:        UInt32 = 0b10
    static let Side:        UInt32 = 0b100
    static let Pipe:        UInt32 = 0b1000
    static let Score:       UInt32 = 0b10000
}
