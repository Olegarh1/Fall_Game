//
//  FloorNode.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 22.02.2024.
//


import SpriteKit

class FloorNode: SKNode {
    
    //MARK: - Properties
    private var node: SKSpriteNode!
    
    //MARK: - Initializes
    override init() {
        super.init()
        
        self.name = "Floor"
        self.zPosition = 5.0
        self.setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: - Setups
extension FloorNode {
    
    private func setupPhysics() {
        let size = CGSize(width: screenWidth, height: 5.0)
        node = SKSpriteNode(color: .clear, size: size)
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.mass = 100.0
        node.physicsBody?.restitution = 0.0
        node.physicsBody?.categoryBitMask = PhysicsCategory.Side
        addChild(node)
    }
}

