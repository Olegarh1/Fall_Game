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
    
    //MARK: - Private UI elements
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "arrow.left")
        button.setImage(image, for: .normal)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.tintColor = .gray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Properties
    private var gameScene =  GameScene(size: CGSize(width: screenWidth, height: screenHeight))
    private var webView = WKWebView()
    private var winnerURL: String = ""
    private var loserURL: String = ""

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
        view.showsFPS = false
        view.showsNodeCount = false
        view.showsPhysics = false
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
        webView = WKWebView(frame: CGRect(x: 0.0, y: 50.0, width: screenWidth, height: screenHeight - 50.0))
        view.addSubview(webView)
        
        guard let myRequest = createURLRequest(from: winnerURL) else {
            print("Failed to create URLRequest")
            return
        }
        webView.load(myRequest)
    }
    
    private func loserWebView() {
        webView = WKWebView(frame: CGRect(x: 0.0, y: 50.0, width: screenWidth, height: screenHeight - 50.0))
        view.addSubview(webView)
        
        guard let myRequest = createURLRequest(from: loserURL) else {
            print("Failed to create URLRequest")
            return
        }
        webView.load(myRequest)
    }
    
    private func addBackButton() {
        backButton.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 50.0)
        backView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 50.0)
        backView.addSubview(backButton)
        view.addSubview(backView)
    }
    
    @objc private func backButtonTapped() {
        backView.removeFromSuperview()
        webView.removeFromSuperview()
    }

}

//MARK: - GameSceneDelegate
extension GameViewController: GameSceneDelegate {
    
    func gameDidEnd(time: Int) {
        addBackButton()
        if time >= 30 {
            winnerWebView()
        } else {
            loserWebView()
        }
    }
}
