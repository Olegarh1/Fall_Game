//
//  GameScene.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 21.02.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: - Properties
    private let worldNode = SKNode()
    private var backgroundNode: SKSpriteNode!
    
    private let playerNode = PlayerNode()
    private let wallNode = WallNode()
    private let floorNode = FloorNode()
    private let leftNode = SideNode()
    private let rightNode = SideNode()
    private let obstangleNode = SKNode()
    
    private var posY: CGFloat = 0.0
    private var isGameOver = false
    private var pairNum = 1
    private var pairCount = 0
    private var firstTap = true

    //MARK: - Lifecycle
    override func didMove(to view: SKView) {
        
        setupNodes()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        if firstTap {
            playerNode.activate(true)
            firstTap = false
        }
        
        //TODO: - Jump
        let location = touch.location(in: self)
        let right = !(location.x > frame.width / 2)
        
        playerNode.jump(right)
    }

    override func update(_ currentTime: TimeInterval) {
        
        if !firstTap && !isGameOver{
            worldNode.position.y += 2
        }
        
        if pairCount <= 5 {
            addObstangle()
        }
        
        // Видаляємо труби, які вийшли за межі екрану
//        obstangleNode.children.forEach { node in
//            if let pairNode = node as? SKNode {
//                if pairNode.position.y < -frame.height {
//                    pairNode.removeFromParent()
//                }
//            }
//        }

    }
}

//MARK: - Setups
extension GameScene {
    
    private func setupNodes() {
        backgroundColor = .white
        setupPhysics()

        //TODO: - BackgroundNode
        addBackground()
        
        //TODO: - WorldNode
        addChild(worldNode)
        
        //TODO: - PlayerNode
        playerNode.position = CGPoint(x: frame.midX, y: frame.midY * 0.6)
        worldNode.addChild(playerNode)
        
        //TODO: - WallNode
        addWall()
        
        //TODO: - ObstangleNode
        worldNode.addChild(obstangleNode)
        posY = frame.midY
    }
    
    //MARK: - Set gravity
    private func setupPhysics() {
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -30.0)
        physicsWorld.contactDelegate = self
    }
}

//MARK: - BackgroundNode
extension GameScene {
    
    private func addBackground() {
        backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.zPosition = -1.0
        backgroundNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(backgroundNode)
    }
}

//MARK: - WallNode
extension GameScene {
    
    private func addWall() {
        wallNode.position = CGPoint(x: frame.midX, y: frame.maxY)
        leftNode.position = CGPoint(x: playableRect.minX, y: frame.midY)
        rightNode.position = CGPoint(x: playableRect.maxX, y: frame.midY)
        floorNode.position = CGPoint(x: frame.midX, y: 0.0)
        [wallNode, leftNode, rightNode, floorNode] .forEach {
            addChild($0)
        }
    }
}

//MARK: - ObstangleNode
extension GameScene {
    
    private func addObstangle() {
        let pipePair = SKNode()
        pipePair.position = CGPoint(x: 0.0, y: posY)
        pipePair.zPosition = 1.0
        pipePair.name = "Pair \(pairNum)"
        
        pairNum += 1
        pairCount += 1
        
        let size = CGSize(width: screenWidth, height: 30.0)
        let pipe1 = SKSpriteNode(color: .black, size: size)
        let posX = Double.random(in: -200...70)
        pipe1.name = "Left \(pairNum)"
        pipe1.position = CGPoint(x: posX, y: 0.0)
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: size)
        pipe1.physicsBody?.isDynamic = false
        pipe1.physicsBody?.categoryBitMask = PhysicsCategory.Pipe
        pipe1.physicsBody?.contactTestBitMask = PhysicsCategory.Wall
        
        let pipe2 = SKSpriteNode(color: .black, size: size)
        pipe2.name = "Right \(pairNum)"
        pipe2.position = CGPoint(x: pipe1.position.x + size.width + 130, y: 0.0)
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: size)
        pipe2.physicsBody?.isDynamic = false
        pipe2.physicsBody?.categoryBitMask = PhysicsCategory.Pipe
        pipe2.physicsBody?.contactTestBitMask = PhysicsCategory.Wall
        
        pipePair.addChild(pipe1)
        pipePair.addChild(pipe2)
        
        obstangleNode.addChild(pipePair)
        posY -= frame.midY * 0.5
    }
}
 
//MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let body = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        switch body.categoryBitMask {
        case PhysicsCategory.Wall:
            isGameOver = true
            playerNode.over()
        default: break
        }
    }
}
