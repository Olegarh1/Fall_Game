//
//  WallNode.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 21.02.2024.
//

import SpriteKit

class WallNode: SKNode {
    
    //MARK: - Properties
    private var node: SKSpriteNode!
    
    //MARK: - Initializes
    override init() {
        super.init()
        
        self.name = "Wall"
        self.zPosition = 5.0

        self.setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: - Setups
extension WallNode {
    
    private func setupPhysics() {
        let size = CGSize(width: screenWidth, height: 30.0)
        node = SKSpriteNode(color: .clear, size: size)
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.mass = 100.0
        node.physicsBody?.restitution = 1.0
        node.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        node.physicsBody?.collisionBitMask = PhysicsCategory.Player
        addChild(node)
    }
}
