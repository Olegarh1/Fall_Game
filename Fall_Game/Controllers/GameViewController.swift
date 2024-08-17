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

    //MARK: - Lifecycle
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
        APIManager.shared.fetchData { [self] result in
            switch result {
            case .success(let gameOver):
                winnerURL = gameOver.winner
                loserURL = gameOver.loser
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func createURLRequest(from urlString: String) -> URLRequest? {

        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            showErrorMessage("Invalid URL: \(urlString)")
            return nil
        }
        
        return URLRequest(url: url)
    }

    
    private func winnerWebView() {
        webView = WKWebView(frame: CGRect(x: 0.0, y: 50.0, width: screenWidth, height: screenHeight - 50.0))
        view.addSubview(webView)
        
        guard let myRequest = createURLRequest(from: winnerURL) else {
            showErrorMessage("Failed to create URLRequest")
            return
        }
        
        webView.navigationDelegate = self
        webView.load(myRequest)
    }
    
    private func loserWebView() {
        webView = WKWebView(frame: CGRect(x: 0.0, y: 50.0, width: screenWidth, height: screenHeight - 50.0))
        view.addSubview(webView)
        
        guard let myRequest = createURLRequest(from: loserURL) else {
            showErrorMessage("Failed to create URLRequest")
            return
        }
        
        webView.navigationDelegate = self
        webView.load(myRequest)
    }
    
    private func showErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }

    private func addBackButton() {
        backButton.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 50.0)
        backView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 50.0)
        backView.addSubview(backButton)
        view.addSubview(backView)
    }
    
    //MARK: - Private objc function
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

//MARK: - WKNavigationDelegate
extension GameViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showErrorMessage("Failed to load webpage: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if (error as NSError).code == NSURLErrorNotConnectedToInternet {
            showErrorMessage("No internet connection")
        } else {
            showErrorMessage("Failed to load webpage: \(error.localizedDescription)")
        }
    }
}
