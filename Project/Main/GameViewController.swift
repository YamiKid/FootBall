//
//  GameViewController.swift
//  soccer
//
//  Created by user on 15.09.24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func loadView() {
        self.view = SKView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let emptyBackButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = emptyBackButton
        
        if let view = self.view as? SKView {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func restartGameScene() {
        if let skView = self.view as? SKView {
            // Останавливаем текущую сцену
            skView.scene?.removeFromParent()
            
            // Создаем и запускаем новую сцену
            let newGameScene = GameScene(size: skView.bounds.size)
            newGameScene.scaleMode = .aspectFill
            skView.presentScene(newGameScene)
        }
    }
    
    func backMenu() {
        if let skView = self.view as? SKView {
            skView.scene?.removeFromParent()
            
            self.navigationController?.popViewController(animated: true)
        }
    }

}
