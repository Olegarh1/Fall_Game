//
//  PlayerNode.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 21.02.2024.
//

import SpriteKit

class PlayerNode: SKNode {
    
    //MARK: - Properties
    private var player: SKShapeNode!
    private let radius: CGFloat = UIScreen.main.bounds.width * 0.05
    
    //MARK: - Initializes
    override init() {
        super.init()
        
        self.name = "Player"
        self.zPosition = 10.0
        self.setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: - Setups
extension PlayerNode {
    
    private func setupPhysics() {
        player = SKShapeNode(circleOfRadius: radius)
        player.name = "Player"
        player.zPosition = .pi
        player.fillColor = .red
        player.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.linearDamping = 0.0
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.restitution = 0.0
        player.physicsBody?.friction = 1.0
        player.physicsBody?.mass = 10.0
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Wall | PhysicsCategory.Score
        player.physicsBody?.collisionBitMask = PhysicsCategory.Side | PhysicsCategory.Pipe
        addChild(player)
    }
    
    internal func activate(_ isDynamic: Bool)  {
        player.fillColor = .red
        player.physicsBody?.isDynamic = isDynamic
    }
    
    internal func over() {
        player.fillColor = .purple
        activate(false)
    }
    
    internal func height() -> CGFloat {
        return player.position.x + screenWidth / 2 * 0.75
    }
    
    internal func width() -> CGFloat {
        return radius * 2.0
    }
}
