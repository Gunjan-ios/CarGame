//
//  GameMenu.swift
//  game
//
//  Created by Gunjan on 13/12/18.
//  Copyright © 2018 Parkland. All rights reserved.
//

import Foundation
import SpriteKit

class GameMenu : SKScene{
    
    var startGame = SKLabelNode()
    var BestScore = SKLabelNode()
    var gamesettings = settings.sharedInstance
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint (x: 0.5, y: 0.5)
        startGame = self.childNode(withName: "startGame") as! SKLabelNode
        BestScore = self.childNode(withName: "BestScore") as! SKLabelNode
        BestScore.text = "Best : \(gamesettings.highScore)"

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchloaction = touch.location(in: self)
            if atPoint(touchloaction).name == "startGame"
            {
                let GameScene = SKScene(fileNamed: "GameScene")!
                GameScene.scaleMode = .aspectFill
                view?.presentScene(GameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
            }
        }
    }
    
    
    
}
