//
//  Types.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 21.02.2024.
//


import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

var playableRect: CGRect {
    let ratio: CGFloat = 2.16
    let w: CGFloat = screenHeight / ratio
    let h: CGFloat = screenHeight
    let x: CGFloat = (screenWidth - w) / 2
    let y: CGFloat = 0.0
    
    return CGRect(x: x, y: y, width: w, height: h)
}
