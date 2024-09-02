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
    let screenRatio = screenWidth / screenHeight
    let baseRatio: CGFloat = 2.16

    let w: CGFloat
    let h: CGFloat
    if screenRatio > baseRatio {
        h = screenHeight
        w = h * baseRatio
    } else {
        w = screenWidth
        h = w / baseRatio
    }

    let x: CGFloat = (screenWidth - w) / 2
    let y: CGFloat = (screenHeight - h) / 2

    return CGRect(x: x, y: y, width: w, height: h)
}

