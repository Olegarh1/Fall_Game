//
//  StartScene.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 23.02.2024.
//


import SwiftUI
import SpriteKit

final class StartScene: SKScene {
    
    //MARK: - Properties
    private var backgroundNode: SKSpriteNode!
    
    //MARK: - Lifecycle
    override func didMove(to view: SKView) {

        self.size = CGSize(width: screenWidth, height: screenHeight)
        addBackground()
        scene?.scaleMode = .aspectFill
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self)
            let startNode = atPoint(location)
            
            if startNode.name == "startButton" {
                let game = GameScene(size: self.size)
                let transition = SKTransition.doorway(withDuration: 1.5)
                
                self.view?.presentScene(game, transition: transition)
            }
        }
    }
}

//MARK: - BackgroundNode
extension StartScene {
    
    private func addBackground() {
        backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.zPosition = -1.0
        backgroundNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(backgroundNode)
    }
}
