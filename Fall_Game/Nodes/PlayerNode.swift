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
    private let radius: CGFloat = 20.0
    
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
        player.physicsBody = SKPhysicsBody(circleOfRadius: radius * 0.8)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.linearDamping = 0.0
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.restitution = 0.0
        player.physicsBody?.friction = 1.0
        player.physicsBody?.mass = 10.0
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Wall | PhysicsCategory.Side | PhysicsCategory.Obstangles
        player.physicsBody?.collisionBitMask = PhysicsCategory.Side
        addChild(player)
    }
    
    internal func activate(_ isDynamic: Bool)  {
        player.physicsBody?.isDynamic = isDynamic
    }
    
    internal func jump(_ right: Bool) {
        let velocity = CGVector(dx: right ? -200 : 200, dy: 1000.0)
        player.physicsBody?.velocity = velocity
    }
    
    internal func over() {
        player.fillColor = .purple
        activate(false)
    }
    
    internal func side() {
        player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 50.0))
    }
    
    internal func height() -> CGFloat {
        return player.position.x + screenWidth / 2 * 0.75
    }
}
