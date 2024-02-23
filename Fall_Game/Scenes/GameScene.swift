//
//  GameScene.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 21.02.2024.
//

import SpriteKit
import GameplayKit

protocol GameSceneDelegate: AnyObject {
    func gameDidEnd(time: Int)
}

final class GameScene: SKScene {
    
    //MARK: - Delegate
    weak var gameDelegate: GameSceneDelegate?
    
    //MARK: - Private UI elements
    private let countDownLable = {
        var label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Time: 0"
        label.fontColor = .init(red: 30/255, green: 129/255, blue: 61/255, alpha: 1.0)
        label.fontSize = 24.0
        label.zPosition = 2.0
        label.horizontalAlignmentMode = .left
        
        return label
    }()
    
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
    private var pairNum = 0
    private var pairCount = 0
    private var isGameOver = false
    private var firstTap = true
    
    private var counter = 0
    private var counterTimer = Timer()
    
    //MARK: - Lifecycle
    override func didMove(to view: SKView) {
        
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        if firstTap {
            playerNode.activate(true)
            startCounter()
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
    }
    
    private func startCounter() {
        counterTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrementTimer), userInfo: nil, repeats: true)
    }
    
    @objc func decrementTimer() {
        
        if !isGameOver {
            counter += 1
            countDownLable.text = "Time: \(counter)"
        }
    }
}

//MARK: - Setups
extension GameScene {
    
    private func setupNodes() {
        backgroundColor = .white
        setupPhysics()
        
        addBackground()
        addWall()
        
        countDownLable.position = CGPoint(x: frame.midX, y: frame.maxY * 0.9)
        playerNode.position = CGPoint(x: frame.midX, y: frame.maxY * 0.8)
        addChild(countDownLable)
        addChild(worldNode)
        
        worldNode.addChild(playerNode)
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
            gameDelegate?.gameDidEnd(time: counter)
            playerNode.over()
        default: break
        }
    }
}
