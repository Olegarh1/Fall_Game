//
//  GameViewController.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 21.02.2024.
//

import UIKit
import WebKit
import SpriteKit
import GameplayKit

final class GameViewController: UIViewController {
    
    //MARK: - Properties
    private let startScene = StartScene(fileNamed: "StartScene")
    private var gameScene =  GameScene(size: CGSize(width: screenWidth, height: screenHeight))
    private var webView = WKWebView()
    private var winnerURL: String = ""
    private var loserURL: String = ""
    private var timer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameScene.gameDelegate = self
        loadURL()
        loadGameScene()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Private function
    private func loadGameScene() {
        guard let view = self.view as? SKView else {
            return
        }
        
        gameScene.scaleMode = .aspectFill
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = true
        view.presentScene(gameScene)
    }
    
    private func loadURL() {
        APIManager.shared.fetchData { result in
            switch result {
            case .success(let gameOver):
                self.winnerURL = gameOver.winner
                self.loserURL = gameOver.loser
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func createURLRequest(from urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        
        return URLRequest(url: url)
    }
    
    private func winnerWebView() {
        webView = WKWebView(frame: self.view.frame)
        view.addSubview(webView)
        
        guard let myRequest = createURLRequest(from: winnerURL) else {
            print("Failed to create URLRequest")
            return
        }
        webView.load(myRequest)
    }
    
    private func loserWebView() {
        webView = WKWebView(frame: self.view.frame)
        view.addSubview(webView)
        
        guard let myRequest = createURLRequest(from: loserURL) else {
            print("Failed to create URLRequest")
            return
        }
        webView.load(myRequest)
    }
}

//MARK: - GameSceneDelegate
extension GameViewController: GameSceneDelegate {
    
    func gameDidEnd(time: Int) {
        if time >= 30 {
            winnerWebView()
        } else {
            loserWebView()
        }
    }
}
