//
//  GameScene.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 21.02.2024.
//

import SpriteKit
import CoreMotion
import GameplayKit

protocol GameSceneDelegate: AnyObject {
    func gameDidEnd(time: Int)
}

final class GameScene: SKScene {
    
    //MARK: - Delegates
    weak var gameDelegate: GameSceneDelegate?
    
    //MARK: - Private UI elements
    private let countDownLable = {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Time: 0"
        label.fontColor = .init(red: 30/255, green: 129/255, blue: 61/255, alpha: 1.0)
        label.fontSize = 24.0
        label.zPosition = 2.0
        label.horizontalAlignmentMode = .left
        
        return label
    }()
    private lazy var startLabel = {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Start Game"
        label.fontSize = 36
        label.fontColor = .init(red: 30/255, green: 129/255, blue: 61/255, alpha: 1.0)
        label.zPosition = 10
        label.position = CGPoint(x: frame.midX, y: frame.midY + 25.0)
        label.name = "startButton"
        
        return label
    }()
    private lazy var restartLabel = {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Restart Game"
        label.fontSize = 36
        label.fontColor = .init(red: 30/255, green: 129/255, blue: 61/255, alpha: 1.0)
        label.scene?.backgroundColor = .blue
        label.zPosition = 10
        label.position = CGPoint(x: frame.midX, y: frame.midY + 25.0)
        label.name = "restartButton"
        label.isHidden = true
        
        return label
    }()
    private let worldNode = SKNode()
    private var backgroundNode: SKSpriteNode!
    private var playerNode = PlayerNode()
    private let wallNode = WallNode()
    private let floorNode = FloorNode()
    private let leftNode = SideNode()
    private let rightNode = SideNode()
    private let obstangleNode = SKNode()
    
    //MARK: - Properties
    private let motionManager = CMMotionManager()
    private var posY: CGFloat = 0.0
    private var pairNum = 0
    private var score = 0
    private var pipeSpawnCount = 0
    private let ballSpeed = 28.0
    private var isStartGame = false
    
    private var counter = 0
    private var counterTimer = Timer()
    
    //MARK: - Lifecycle
    override func didMove(to view: SKView) {
        
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let location = touch.location(in: self)
            let startNode = atPoint(location)
            
            if startNode.name == "startButton" {
                isStartGame = true
                startLabel.isHidden = true
                motionManager.startAccelerometerUpdates()
                playerNode.activate(true)
                startCounter()
            }
            
            if startNode.name == "restartButton" {
                restartGame()
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        
        accelometr()
        setupWorldSpeed()
        spawnPipePair()
        deletePipePair()
    }
    
    //MARK: - Private function
    private func accelometr() {
        if isStartGame {
            if let data = motionManager.accelerometerData {
                let acceleration = data.acceleration.x
                self.playerNode.position.x += acceleration * 15.0
            }
        }
    }
    
    private func startCounter() {
        counterTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrementTimer), userInfo: nil, repeats: true)
    }
    
    private func restartGame() {
        playerNode.removeFromParent()
        obstangleNode.removeAllChildren()
        
        playerNode = PlayerNode()
        playerNode.position = CGPoint(x: frame.midX, y: frame.maxY * 0.8)
        worldNode.addChild(playerNode)
        
        posY = frame.midY
        pipeSpawnCount = 0
        score = 0
        pairNum = 0
        counter = 0
        countDownLable.text = "Time: 0"
        worldNode.position.y = 0
        restartLabel.isHidden = true
        isStartGame = true
        
        motionManager.startAccelerometerUpdates()
        playerNode.activate(true)
        startCounter()
    }
    
    //MARK: - Private objc function
    @objc private func decrementTimer() {
        if isStartGame {
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
        
        countDownLable.position = CGPoint(x: frame.maxX - 150.0, y: frame.maxY * 0.9)
        playerNode.position = CGPoint(x: frame.midX, y: frame.maxY * 0.8)
        [countDownLable, worldNode, startLabel, restartLabel].forEach {
            addChild($0)
        }
        
        worldNode.addChild(playerNode)
        worldNode.addChild(obstangleNode)
        
        posY = frame.midY
    }

    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -ballSpeed)
        physicsWorld.contactDelegate = self
    }
    
    private func setupWorldSpeed() {
        if isStartGame {
            let speedUp = ballSpeed - 25.0
            if speedUp > 0 {
                worldNode.position.y += speedUp
            } else {
                worldNode.position.y += 2
            }
        }
    }
    
    private func spawnPipePair() {
        if pipeSpawnCount < 10 {
            pipeSpawnCount += 1
            addObstangle()
        }
    }
    
    private func deletePipePair() {
        obstangleNode.children.forEach({
            let i = score - 5
            if $0.name == "Pair \(i)" && i >= 0 {
                $0.removeFromParent()
                addObstangle()
            }
        })
    }
}

//MARK: - BackgroundNode
extension GameScene {
    
    private func addBackground() {
        backgroundNode = SKSpriteNode(color: .cyan, size: self.size)
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
    
    //TODO: - Random spawn
    private func addObstangle() {
        let pipePair = SKNode()
        pipePair.position = CGPoint(x: 0.0, y: posY)
        pipePair.zPosition = 1.0
        
        pairNum += 1
        pipePair.name = "Pair \(pairNum)"
        
        let pipeHeight: CGFloat = self.size.height * 0.03
        let space = playerNode.width() * CGFloat.random(in: 1...2)
        let randomSpaceX = CGFloat.random(in: 0...(frame.width - space))
        let leftPipeWidth = randomSpaceX
        let rightPipeWidth = frame.width - randomSpaceX - space
        
        let leftPipeSize = CGSize(width: leftPipeWidth, height: pipeHeight)
        let leftPipe = SKSpriteNode(color: .black, size: leftPipeSize)
        leftPipe.position = CGPoint(x: leftPipeWidth / 2, y: 0.0)
        leftPipe.physicsBody = SKPhysicsBody(rectangleOf: leftPipeSize)
        leftPipe.physicsBody?.isDynamic = false
        leftPipe.physicsBody?.categoryBitMask = PhysicsCategory.Pipe

        let rightPipeSize = CGSize(width: rightPipeWidth, height: pipeHeight)
        let rightPipe = SKSpriteNode(color: .black, size: rightPipeSize)
        rightPipe.position = CGPoint(x: randomSpaceX + space + rightPipeWidth / 2, y: 0.0)
        rightPipe.physicsBody = SKPhysicsBody(rectangleOf: rightPipeSize)
        rightPipe.physicsBody?.isDynamic = false
        rightPipe.physicsBody?.categoryBitMask = PhysicsCategory.Pipe

        let score = SKNode()
        score.position = CGPoint(x: randomSpaceX + space / 2, y: 0.0)
        score.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: space, height: pipeHeight))
        score.physicsBody?.isDynamic = false
        score.physicsBody?.categoryBitMask = PhysicsCategory.Score

        pipePair.addChild(leftPipe)
        pipePair.addChild(rightPipe)
        pipePair.addChild(score)
        
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
            isStartGame = false
            worldNode.position.y = 0
            motionManager.stopAccelerometerUpdates()
            restartLabel.isHidden = false
            counterTimer.invalidate()
            gameDelegate?.gameDidEnd(time: counter)
            playerNode.over()
        case PhysicsCategory.Score:
            if let node = body.node {
                score += 1
                node.removeFromParent()
            }
        default: break
        }
    }
}
