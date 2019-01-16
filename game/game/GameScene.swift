//
//  GameScene.swift
//  game
//
//  Created by Gunjan on 12/12/18.
//  Copyright © 2018 Parkland. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var  leftCar = SKSpriteNode()
    var  rightCar = SKSpriteNode()
    
    var canMove = false
    var leftToMoveLeft = true
    var rightcarToMoveRight = true
    
    var leftCarAtRight = false
    var rightCarAtleft = false
    var centerPoint : CGFloat!

    let leftCarminmumX : CGFloat = -280
    let leftCarmaximumX : CGFloat = -100
    
    let rightCarminmumX : CGFloat = 100
    let rightCarmaximumX : CGFloat = 280
    
    var score  = 0
    var countDown = 1
    var stopEverything = true
    
    var scoreText = SKLabelNode()
    
    var gamesettings =   settings.sharedInstance
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint (x: 0.5, y: 0.5)
       setup()
        physicsWorld.contactDelegate = self
         Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.createRoadStrip), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.startCountDown), userInfo: nil, repeats: true)
        
          Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwonumbers(firstnumber: 0.2, secondnumber: 1)), target: self, selector: #selector(GameScene.leftTraffic), userInfo: nil, repeats: true)
          Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwonumbers(firstnumber: 0.2, secondnumber: 1)), target: self, selector: #selector(GameScene.RightTraffic), userInfo: nil, repeats: true)
        
         Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.removeItem), userInfo: nil, repeats: true)
        
        let deadtime =  DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadtime) {
             Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.IncresScore), userInfo: nil, repeats: true)
        }
        
     }

    func setup()
    {
        leftCar = self.childNode(withName: "leftCar") as! SKSpriteNode
        rightCar = self.childNode(withName: "rightCar") as! SKSpriteNode
        centerPoint = self.frame.size.width / self.frame.size.height
        
        leftCar.physicsBody?.categoryBitMask = colliderType.CAR_COLLIDER
        leftCar.physicsBody?.contactTestBitMask = colliderType.ITEM_COLLIDER
        leftCar.physicsBody?.collisionBitMask = 0
        
        rightCar.physicsBody?.categoryBitMask = colliderType.CAR_COLLIDER
        rightCar.physicsBody?.contactTestBitMask = colliderType.ITEM_COLLIDER1
        rightCar.physicsBody?.collisionBitMask = 0
        
        let scoreBackground = SKShapeNode (rect: CGRect (x: -self.size.width/2 + 70 , y: self.size.height/2 - 130, width: 180, height: 80), cornerRadius: 20)
        scoreBackground.zPosition = 4
        scoreBackground.fillColor = SKColor.black.withAlphaComponent(0.3)
        scoreBackground.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(scoreBackground)
        scoreText.name = "score"
        scoreText.fontName = "AvenirNext-Bold"
        scoreText.text = "0"
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint (x: -self.size.width/2 + 160 , y: self.size.height/2 - 110)
        scoreText.fontSize = 50
        scoreText.zPosition = 4
        addChild(scoreText)
        
        
        
        
    }
    
 func showRoadstrip()
 {
    enumerateChildNodes(withName: "leftRoadStrip") { (roadStrip, stop) in
        let strip = roadStrip as! SKShapeNode
        strip.position.y -= 30
    }
    enumerateChildNodes(withName: "rightRoadStrip") { (roadStrip, stop) in
        let strip = roadStrip as! SKShapeNode
        strip.position.y -= 30
    }
    enumerateChildNodes(withName: "orangeCar") { (leftcar, stop) in
        let leftcar = leftcar as! SKSpriteNode
        leftcar.position.y -= 15
    }
    enumerateChildNodes(withName: "GreenCar") { (leftcar, stop) in
        let leftcar = leftcar as! SKSpriteNode
        leftcar.position.y -= 15
    }
//    enumerateChildNodes(withName: "RedCar") { (leftcar, stop) in
//        let leftcar = leftcar as! SKSpriteNode
//        leftcar.position.y -= 15
//    }
    enumerateChildNodes(withName: "YellowCar") { (leftcar, stop) in
        let leftcar = leftcar as! SKSpriteNode
        leftcar.position.y -= 15
    }
    enumerateChildNodes(withName: "BlueCar") { (rightcar, stop) in
        let rightcar = rightcar as! SKSpriteNode
        rightcar.position.y -= 15
    }
    
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if canMove
        {
            move(leftside: leftToMoveLeft)
            moveRightCar(rightside: rightcarToMoveRight)
        }
        showRoadstrip()
        
    }
    
    
    @objc func startCountDown(){
        if countDown>0
        {
            if countDown < 4
            { let countdownLabel = SKLabelNode()
                countdownLabel.fontName = "AvenirNext-Bold"
                countdownLabel.fontColor = SKColor.white
                countdownLabel.fontSize = 300
                countdownLabel.text = String(countDown)
                countdownLabel.position = CGPoint (x: 0, y: 0)
                countdownLabel.zPosition = 300
                countdownLabel.name = "clabel"
                countdownLabel.horizontalAlignmentMode = .center
                addChild(countdownLabel)
                
                let deadTime = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: deadTime, execute: {
                    countdownLabel.removeFromParent()
                } )
            }
            countDown += 1
            if countDown == 4 {
                self.stopEverything = false
            }
        }
    }
    @objc func IncresScore()
    {
        if !stopEverything{
            score += 1
            scoreText.text = String(score)
        }
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody  = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "leftCar" ||  contact.bodyA.node?.name == "rightCar"
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        firstBody.node?.removeFromParent()
        afterCollision()
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchloaction = touch.location(in: self)
            if touchloaction.x > centerPoint{
                if rightCarAtleft{
                    rightCarAtleft = false
                    rightcarToMoveRight = true
                }else
                {
                    rightCarAtleft = true
                    rightcarToMoveRight = false
                }
            }
            else
            {
                if leftCarAtRight{
                    leftCarAtRight = false
                    leftToMoveLeft = true
                }else
                {
                    leftCarAtRight = true
                    leftToMoveLeft = false
                }
            }
            canMove = true
        }
    }
    
    @objc func createRoadStrip()
    {
        let  leftRoadStrip = SKShapeNode (rectOf: CGSize (width: 10, height: 40))
        leftRoadStrip.strokeColor = SKColor.white
        leftRoadStrip.fillColor = SKColor.white
        leftRoadStrip.alpha = 0.4
        leftRoadStrip.name = "leftRoadStrip"
        leftRoadStrip.zPosition = 10
        leftRoadStrip.position.x = -187.5
        leftRoadStrip.position.y = 700
        addChild(leftRoadStrip)
        
        let  rightRoadStrip = SKShapeNode (rectOf: CGSize (width: 10, height: 40))
        rightRoadStrip.strokeColor = SKColor.white
        rightRoadStrip.fillColor = SKColor.white
        rightRoadStrip.alpha = 0.4
        rightRoadStrip.name = "rightRoadStrip"
        rightRoadStrip.zPosition = 10
        rightRoadStrip.position.x = 187.5
        rightRoadStrip.position.y = 700
        addChild(rightRoadStrip)
        
        
    }
   
    @objc func removeItem()
    {
        for child in children{
            if child.position.y < -self.size.height - 150{
                child.removeFromParent()
            }
        }
    }
    
    
    func  move(leftside:Bool)
    {
        if leftside{
            leftCar.position.x -= 20
            if leftCar.position.x < leftCarminmumX{
                leftCar.position.x = leftCarminmumX
            }
        }
        else
        {
            leftCar.position.x += 20
            if leftCar.position.x > leftCarmaximumX{
                leftCar.position.x = leftCarmaximumX
            }
        }
    }
    
    func  moveRightCar(rightside:Bool)
    {
        if rightside{
            rightCar.position.x += 20
            if rightCar.position.x > rightCarmaximumX{
                rightCar.position.x = rightCarmaximumX
            }
        }
        else
        {
            rightCar.position.x -= 20
            if rightCar.position.x < rightCarminmumX{
                rightCar.position.x = rightCarminmumX
            }
        }
    }
    
    @objc func leftTraffic()
    {
        if !stopEverything{
        let lefttraficItem : SKSpriteNode!
        let randomNumber = Helper().randomBetweenTwonumbers(firstnumber: 1, secondnumber: 20
        )
            switch Int(randomNumber) {
            case 1...4:
                lefttraficItem = SKSpriteNode (imageNamed: "Orange")
                lefttraficItem.name = "orangecar"
                break
            case 5...10:
                lefttraficItem = SKSpriteNode (imageNamed: "Green")
                lefttraficItem.name = "GreenCar"
                break
            case 11...15:
                lefttraficItem = SKSpriteNode (imageNamed: "Blue")
                lefttraficItem.name = "BlueCar"
                break
            case 16...20:
                lefttraficItem = SKSpriteNode (imageNamed: "Yellow")
                lefttraficItem.name = "YellowCar"
                break
//            case 17...20:
//                lefttraficItem = SKSpriteNode (imageNamed: "Orange")
//                lefttraficItem.name = "orangecar"
//                break
            default:
                lefttraficItem = SKSpriteNode (imageNamed: "Red")
                lefttraficItem.name = "RedCar"
            }
        lefttraficItem.anchorPoint = CGPoint (x: 0.5, y: 0.5)
        lefttraficItem.zPosition = 10
        let randomNum = Helper () .randomBetweenTwonumbers(firstnumber: 1, secondnumber: 20)
        switch Int(randomNum) {
        case  1...4:
            lefttraficItem.position.x = -280
            break
        case 5...10:
                lefttraficItem.position.x = -100
            break
        case 11...15:
            lefttraficItem.position.x = -280
            break
        case 16...20:
            lefttraficItem.position.x = -100
            break
        default:
            lefttraficItem.position.x = -280

        }
        lefttraficItem.position.y = 700
        lefttraficItem.physicsBody = SKPhysicsBody (circleOfRadius: lefttraficItem.size.height/2)
        lefttraficItem.physicsBody?.categoryBitMask = colliderType.ITEM_COLLIDER
        lefttraficItem.physicsBody?.collisionBitMask = 0
        lefttraficItem.physicsBody?.affectedByGravity = false
        
        addChild(lefttraficItem)
        }
    }
    
    @objc func RightTraffic()
    {
        if !stopEverything {
        let RightTrafficicItem : SKSpriteNode!
        let randomNumber = Helper().randomBetweenTwonumbers(firstnumber: 1, secondnumber: 20
        )
        switch Int(randomNumber) {
        case 1...4:
            RightTrafficicItem = SKSpriteNode (imageNamed: "Orange")
            RightTrafficicItem.name = "orangecar"
            break
        case 5...10:
            RightTrafficicItem = SKSpriteNode (imageNamed: "Green")
            RightTrafficicItem.name = "GreenCar"
            break
        case 11...15:
            RightTrafficicItem = SKSpriteNode (imageNamed: "Blue")
            RightTrafficicItem.name = "BlueCar"
            break
        case 16...20:
            RightTrafficicItem = SKSpriteNode (imageNamed: "Yellow")
            RightTrafficicItem.name = "YellowCar"
            break
//        case 17...20:
//            RightTrafficicItem = SKSpriteNode (imageNamed: "Orange")
//            RightTrafficicItem.name = "orangecar"
//            break
        default:
            RightTrafficicItem = SKSpriteNode (imageNamed: "Red")
            RightTrafficicItem.name = "RedCar"
           
        }
        RightTrafficicItem.anchorPoint = CGPoint (x: 0.5, y: 0.5)
        RightTrafficicItem.zPosition = 10
        let randomNum = Helper () .randomBetweenTwonumbers(firstnumber: 1, secondnumber: 20)
        switch Int(randomNum) {
        case  1...4:
            RightTrafficicItem.position.x = 280
            break
        case 5...10:
            RightTrafficicItem.position.x = 100
            break
        case 11...15:
            RightTrafficicItem.position.x = 280
            break
        case 16...20:
            RightTrafficicItem.position.x = 100
            break
        default:
            RightTrafficicItem.position.x = 280
        }
        RightTrafficicItem.position.y = 700
        RightTrafficicItem.physicsBody = SKPhysicsBody (circleOfRadius: RightTrafficicItem.size.height/2)
        RightTrafficicItem.physicsBody?.categoryBitMask = colliderType.ITEM_COLLIDER1
        RightTrafficicItem.physicsBody?.collisionBitMask = 0
        RightTrafficicItem.physicsBody?.affectedByGravity = false
        
        addChild(RightTrafficicItem)
        }
    }
   
    func afterCollision(){
        
        if gamesettings.highScore < score
        {
            gamesettings.highScore = score
        }
        
        let menuScene = SKScene(fileNamed: "GameMenu")!
        menuScene.scaleMode = .aspectFill
        view?.presentScene(menuScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
    }
}
