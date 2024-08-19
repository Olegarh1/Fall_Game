//
//  SideNode.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 21.02.2024.
//

import SpriteKit

class SideNode: SKNode {
    
    //MARK: - Properties
    private var node: SKSpriteNode!
    
    //MARK: - Initializes
    override init() {
        super.init()
        
        self.name = "Side"
        self.zPosition = 10.0
        self.setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: - Setups
extension SideNode {
    
    private func setupPhysics() {
        let size = CGSize(width: 5.0, height: screenHeight)
        node = SKSpriteNode(color: .clear, size: size)
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.friction = 1.0
        node.physicsBody?.restitution = 0.0
        node.physicsBody?.categoryBitMask = PhysicsCategory.Side
        addChild(node)
    }
}
