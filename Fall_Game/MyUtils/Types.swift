//
//  Types.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 21.02.2024.
//


import UIKit

let screenWidth: CGFloat = 414.0
let screenHeight: CGFloat = 896.0

var playableRect: CGRect {
    let ratio: CGFloat = 2.16
    let w: CGFloat = screenHeight / ratio
    let h: CGFloat = screenHeight
    let x: CGFloat = (screenWidth - w) / 2
    let y: CGFloat = 0.0
    
    return CGRect(x: x, y: y, width: w, height: h)
}

struct PhysicsCategory {
    static let Player:      UInt32 = 0b1
    static let Wall:        UInt32 = 0b10
    static let Side:        UInt32 = 0b100
    static let Obstangles:  UInt32 = 0b1000
}
