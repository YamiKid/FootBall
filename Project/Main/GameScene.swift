//
//  GameScene.swift
//  soccer
//
//  Created by user on 15.09.24.
//

import SpriteKit
import GameplayKit

extension Notification.Name {
    static let didFinishInstruction = Notification.Name("didFinishInstruction")
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "playerImage3")
    let redPlayer = SKSpriteNode(imageNamed: "redPlayerImage")
    let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"))
    let infoButton = SKSpriteNode(imageNamed: "freezeButton")
    
    var moveSpeed: CGFloat = GameData.shared.moveSpeed
    
    var gamePaused = false
    
    var label6: SKLabelNode!
    var label5: SKLabelNode!
    var label4: SKLabelNode!
    
    var currentLevel: Level?
    var timeLeft: Int = 0
    var targetGoal: Int = 0
    
    var t = 1
    var timer: Timer?
    
    var youScore = 0
    var aiScore = 0
    
    
    var flagButton = true
    
    var lastTouchPosition: CGPoint?

    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .white
        physicsWorld.contactDelegate = self
        
        loadLevel(levelNumber: LevelManager.shared.getNowLevel())
        
        if let level = currentLevel {

            timeLeft = Int(level.timeLimit)
            targetGoal = level.targetScore
            
            print("Loaded Level \(level.levelNumber) with Target: \(targetGoal) and Time: \(timeLeft) seconds")
        }
        
        addBackgroundImages()
        addGates()
        addScoreBoard()
        addLabels()
        addBorder()
        addPlayer()
        addRedPlayer()
        addBall()
        addMenuButton()
        startTimer()
        startAnimation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(resumeGame), name: .didFinishInstruction, object: nil)
        
        if LevelManager.shared.getNowLevel() == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showTutorialController()
                    }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showDescriptionLevel()
                    }
        }
    }
    
    func loadLevel(levelNumber: Int) {
        if levelNumber > 0 && levelNumber <= levels.count {
            currentLevel = levels[levelNumber - 1]
        } else {
            print("Invalid level number")
        }
    }
    
    @objc func resumeGame() {

        gamePaused = false
        t = 1
        self.isPaused = false
        self.isUserInteractionEnabled = true
    }
    
    deinit {
           NotificationCenter.default.removeObserver(self)
       }
    
    func showTutorialController() {
        gamePaused = true
        t = 0
        
        self.isPaused = true
        self.isUserInteractionEnabled = false
    
        guard let viewController = self.view?.window?.rootViewController else {
            print("Ошибка: rootViewController не найден")
            return
        }
        let firstInstruction = FirstInstruction()
        firstInstruction.modalPresentationStyle = .overFullScreen
        viewController.present(firstInstruction, animated: true, completion: nil)
        }
    
    func showDescriptionLevel() {
        gamePaused = true
        t = 0
        
        self.isPaused = true
        self.isUserInteractionEnabled = false
    
        guard let viewController = self.view?.window?.rootViewController else {
            print("Ошибка: rootViewController не найден")
            return
        }
        let firstInstruction = DescriptionLevel()
        firstInstruction.modalPresentationStyle = .overFullScreen
        viewController.present(firstInstruction, animated: true, completion: nil)
        }
    
    private func startAnimation() {
            let textures = [
                SKTexture(imageNamed: "playerImage1"),
                SKTexture(imageNamed: "playerImage2"),
                SKTexture(imageNamed: "playerImage3")
            ]

            let animateAction = SKAction.animate(with: textures, timePerFrame: 0.3)

            let repeatAction = SKAction.repeatForever(animateAction)

            player.run(repeatAction)
        
            let textures1 = [
                SKTexture(imageNamed: "redPlayerImage1"),
                SKTexture(imageNamed: "redPlayerImage2"),
                SKTexture(imageNamed: "redPlayerImage3")
            ]

            let animateAction1 = SKAction.animate(with: textures1, timePerFrame: 0.3)

            let repeatAction1 = SKAction.repeatForever(animateAction1)

            redPlayer.run(repeatAction1)
        }
    
    func startTimer() {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    
    @objc func updateTime() {
        // Уменьшаем время на 1 секунду
        timeLeft -= t
        
        label5.text = String(format: "00:%02d", timeLeft)
        
        if timeLeft <= 0 {
            // Останавливаем таймер
            timer?.invalidate()
            timer = nil
            
            handleTimeUp()
        }
    }
    
    func handleTimeUp() {
        
        GameData.shared.youScore = self.youScore
        GameData.shared.aiScore = self.aiScore
        GameData.shared.time = self.timeLeft
        
        gameOver()
    }
    private func addBackgroundImages() {
        let smallTexture = SKTexture(imageNamed: "scoreBG")
        let largeTexture = SKTexture(imageNamed: "fieldBG")
        let gameField = SKTexture(imageNamed: "fieldGame")
        
        let screenWidth = size.width
        let screenHeight = size.height

        let smallImageNode = SKSpriteNode(texture: smallTexture)
        let largeImageNode = SKSpriteNode(texture: largeTexture)
        let gameFieldNode = SKSpriteNode(texture: gameField)
        
        smallImageNode.size = CGSize(width: screenWidth, height: screenHeight * 0.15)
        largeImageNode.size = CGSize(width: screenWidth, height: screenHeight * 0.85)
        gameFieldNode.size = CGSize(width: screenWidth * 0.90, height: screenHeight * 0.65)
        smallImageNode.zPosition = -9
        gameFieldNode.zPosition = -9
        largeImageNode.zPosition = -10
        
        smallImageNode.position = CGPoint(x: screenWidth / 2, y: screenHeight * 0.925)
        largeImageNode.position = CGPoint(x: screenWidth / 2, y: screenHeight * 0.425)
        gameFieldNode.position = CGPoint(x: screenWidth / 2, y: screenHeight * 0.425)
        
        addChild(smallImageNode)
        addChild(largeImageNode)
        addChild(gameFieldNode)
    }
    
    private func addGates() {
        let goal1Texture = SKTexture(imageNamed: "gates")
        let goal2Texture = SKTexture(imageNamed: "gates")
        
        let screenWidth = size.width
        let screenHeight = size.height
        
        let goalHeight = screenHeight * 0.08
        let goalWidth = screenWidth * 0.42
        let goalYPosition = screenHeight * 0.75
        
        let goal1Node = SKSpriteNode(texture: goal1Texture)
        goal1Node.size = CGSize(width: goalWidth, height: goalHeight)
        goal1Node.position = CGPoint(x: screenWidth / 2, y: screenHeight * 0.75)
        goal1Node.zPosition = 1
        
        // Левый пост ворот
        let leftPost = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: goalHeight))
        leftPost.position = CGPoint(x: (screenWidth / 2) - goalWidth / 2, y: goalYPosition)
        leftPost.physicsBody = SKPhysicsBody(rectangleOf: leftPost.size)
        leftPost.physicsBody?.isDynamic = false
        leftPost.physicsBody?.friction = 0
        leftPost.physicsBody?.restitution = 0.5
        leftPost.physicsBody?.categoryBitMask = PhysicsCategory.LeftBoundary1
        leftPost.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Ball
        leftPost.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Ball

        // Правый пост ворот
        let rightPost = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: goalHeight))
        rightPost.position = CGPoint(x: (screenWidth / 2) + goalWidth / 2, y: goalYPosition)
        rightPost.physicsBody = SKPhysicsBody(rectangleOf: rightPost.size)
        rightPost.physicsBody?.isDynamic = false
        rightPost.physicsBody?.friction = 0
        rightPost.physicsBody?.restitution = 0.5
        rightPost.physicsBody?.categoryBitMask = PhysicsCategory.RightBoundary1
        rightPost.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Ball
        rightPost.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Ball

        // Верхний пост ворот
        let topPost = SKSpriteNode(color: .clear, size: CGSize(width: goalWidth, height: 10))
        topPost.position = CGPoint(x: screenWidth / 2, y: goalYPosition + goalHeight / 2)
        topPost.physicsBody = SKPhysicsBody(rectangleOf: topPost.size)
        topPost.physicsBody?.isDynamic = false
        topPost.physicsBody?.friction = 0
        topPost.physicsBody?.restitution = 0.5
        topPost.physicsBody?.categoryBitMask = PhysicsCategory.TopBoundary1
        topPost.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Ball
        topPost.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Ball

        
        let bottomPost = SKSpriteNode(color: .clear, size: CGSize(width: goalWidth, height: 10))
        bottomPost.position = CGPoint(x: screenWidth / 2, y: goalYPosition - goalHeight / 10)
        bottomPost.physicsBody = SKPhysicsBody(rectangleOf: bottomPost.size)
        bottomPost.physicsBody?.isDynamic = false
        bottomPost.physicsBody?.friction = 0
        bottomPost.physicsBody?.restitution = 0
        bottomPost.physicsBody?.categoryBitMask = PhysicsCategory.YouGoal
        bottomPost.physicsBody?.collisionBitMask = PhysicsCategory.Ball
        bottomPost.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        
        addChild(leftPost)
        addChild(rightPost)
        addChild(topPost)
        addChild(bottomPost)
        addChild(goal1Node)
        
        let goal2Node = SKSpriteNode(texture: goal2Texture)
        
        let goalHeight1 = screenHeight * 0.08
        let goalWidth1 = screenWidth * 0.42
        let goalYPosition1 = screenHeight * 0.1
        
        goal2Node.size = CGSize(width: screenWidth * 0.42, height: screenHeight * 0.08)
        goal2Node.position = CGPoint(x: screenWidth / 2, y: goalYPosition1)
        goal2Node.zPosition = 1
        
        let leftPost1 = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: goalHeight1))
        leftPost1.position = CGPoint(x: (screenWidth / 2) - goalWidth1 / 2, y: goalYPosition1)
        leftPost1.physicsBody = SKPhysicsBody(rectangleOf: leftPost1.size)
        leftPost1.physicsBody?.isDynamic = false
        leftPost1.physicsBody?.friction = 0
        leftPost1.physicsBody?.restitution = 0.5
        leftPost1.physicsBody?.categoryBitMask = PhysicsCategory.LeftBoundary2
        leftPost1.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Ball

        let rightPost1 = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: goalHeight1))
        rightPost1.position = CGPoint(x: (screenWidth / 2) + goalWidth1 / 2, y: goalYPosition1)
        rightPost1.physicsBody = SKPhysicsBody(rectangleOf: rightPost1.size)
        rightPost1.physicsBody?.isDynamic = false
        rightPost1.physicsBody?.friction = 0
        rightPost1.physicsBody?.restitution = 0.5
        rightPost1.physicsBody?.categoryBitMask = PhysicsCategory.RightBoundary2
        rightPost1.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Ball

        let topPost1 = SKSpriteNode(color: .clear, size: CGSize(width: goalWidth1, height: 10))
        topPost1.position = CGPoint(x: screenWidth / 2, y: goalYPosition1 - goalHeight1 / 2)
        topPost1.physicsBody = SKPhysicsBody(rectangleOf: topPost1.size)
        topPost1.physicsBody?.isDynamic = false
        topPost1.physicsBody?.friction = 0
        topPost1.physicsBody?.restitution = 0
        topPost1.physicsBody?.categoryBitMask = PhysicsCategory.TopBoundary2
        topPost1.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Ball
        
        
        let bottomPost1 = SKSpriteNode(color: .clear, size: CGSize(width: goalWidth1, height: 10))
        bottomPost1.position = CGPoint(x: screenWidth / 2, y: goalYPosition1 + goalHeight1 / 10)
        bottomPost1.physicsBody = SKPhysicsBody(rectangleOf: bottomPost1.size)
        bottomPost1.physicsBody?.isDynamic = false
        bottomPost1.physicsBody?.friction = 0
        bottomPost1.physicsBody?.restitution = 0.5
        bottomPost1.physicsBody?.categoryBitMask = PhysicsCategory.AIGoal
        bottomPost1.physicsBody?.collisionBitMask = PhysicsCategory.Ball
        bottomPost1.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        
        
        addChild(leftPost1)
        addChild(rightPost1)
        addChild(topPost1)
        addChild(bottomPost1)
        addChild(goal2Node)
    }
    
    private func addScoreBoard() {
        let scoreBoardTexture = SKTexture(imageNamed: "scoreBoard")
        
        let screenWidth = size.width
        let screenHeight = size.height
        
        let scoreBoardTextureNode = SKSpriteNode(texture: scoreBoardTexture)
        scoreBoardTextureNode.size = CGSize(width: screenWidth * 0.4, height: screenHeight * 0.15)
        scoreBoardTextureNode.position = CGPoint(x: screenWidth / 2, y: screenHeight * 0.875)
        
        scoreBoardTextureNode.zPosition = -8
        
        addChild(scoreBoardTextureNode)
    }
    
    private func addLabels() {
        let screenWidth = size.width
        let screenHeight = size.height
        
        let font1Name = "Signika-Bold"
        
        let label1 = SKLabelNode(fontNamed: font1Name)
        label1.text = "YOU"
        label1.fontSize = 18
        label1.fontColor = .white
        label1.position = CGPoint(x: screenWidth * 0.36, y: screenHeight * 0.925)
        addChild(label1)
        
        let label2 = SKLabelNode(fontNamed: font1Name)
        label2.text = "TIME"
        label2.fontSize = 18
        label2.fontColor = .white
        label2.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.925)
        addChild(label2)

        let label3 = SKLabelNode(fontNamed: font1Name)
        label3.text = "AI"
        label3.fontSize = 18
        label3.fontColor = .white
        label3.position = CGPoint(x: screenWidth * 0.63, y: screenHeight * 0.925)
        addChild(label3)
        
        let font2Name = "digitalicg"
        
        label4 = SKLabelNode(fontNamed: font2Name)
        label4.text = "0\(youScore)"
        label4.fontSize = 26
        label4.fontColor = .white
        label4.position = CGPoint(x: screenWidth * 0.365, y: screenHeight * 0.865)
        UserDefaults.standard.set(youScore, forKey: "youScore")
        addChild(label4)
        
        label5 = SKLabelNode(fontNamed: font2Name)
        label5.text = String(format: "00:%02d", timeLeft)
        label5.fontSize = 20
        label5.fontColor = .white
        label5.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.867)
        addChild(label5)

        label6 = SKLabelNode(fontNamed: font2Name)
        label6.text = "0\(aiScore)"
        label6.fontSize = 26
        label6.fontColor = .white
        label6.position = CGPoint(x: screenWidth * 0.635, y: screenHeight * 0.865)
        UserDefaults.standard.set(aiScore, forKey: "aiScore")
        addChild(label6)
    }
    
    private func addBall() {
        let screenWidth = size.width
        let screenHeight = size.height
        
        let ballSize: CGFloat = 30
        ball.size = CGSize(width: ballSize, height: ballSize)
        ball.position = CGPoint(x: screenWidth / 2, y: screenHeight * 0.425)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballSize / 2)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        ball.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.BottomBoundary | PhysicsCategory.LeftBoundary | PhysicsCategory.LeftBoundary1 | PhysicsCategory.RightBoundary | PhysicsCategory.RightBoundary1 | PhysicsCategory.TopBoundary | PhysicsCategory.RightBoundary1 | PhysicsCategory.TopBoundary1 | PhysicsCategory.YouGoal | PhysicsCategory.AIGoal | PhysicsCategory.LeftBoundary2 | PhysicsCategory.RightBoundary2 | PhysicsCategory.TopBoundary2 | PhysicsCategory.RedPlayer
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.YouGoal | PhysicsCategory.RedPlayer | PhysicsCategory.AIGoal
        ball.physicsBody?.friction = 0.8
        ball.physicsBody?.restitution = 0.4
        
        ball.name = "ball"
        
        addChild(ball)
    }
    
    private func addPlayer() {
        let screenWidth = size.width
        let screenHeight = size.height
        
        player.size = CGSize(width: screenWidth*0.145, height: screenHeight*0.09)
        player.position = CGPoint(x: screenWidth/2, y: screenHeight/5)

        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.collisionBitMask = PhysicsCategory.Ball | PhysicsCategory.BottomBoundary | PhysicsCategory.LeftBoundary | PhysicsCategory.LeftBoundary1 | PhysicsCategory.RightBoundary | PhysicsCategory.RightBoundary1 | PhysicsCategory.TopBoundary | PhysicsCategory.RightBoundary1 | PhysicsCategory.TopBoundary1 | PhysicsCategory.RedPlayer
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Ball | PhysicsCategory.RedPlayer
        player.physicsBody?.friction = 0.8
        player.physicsBody?.restitution = 0
        
        addChild(player)
    }
    
    private func addRedPlayer() {
        let screenWidth = size.width
        let screenHeight = size.height
        
        redPlayer.size = CGSize(width: screenWidth*0.145, height: screenHeight*0.09)
        redPlayer.position = CGPoint(x: screenWidth / 2, y: screenHeight*0.68)
        
        redPlayer.physicsBody = SKPhysicsBody(rectangleOf: redPlayer.size)
        redPlayer.physicsBody?.affectedByGravity = false
        redPlayer.physicsBody?.isDynamic = false
        redPlayer.physicsBody?.allowsRotation = false
        redPlayer.physicsBody?.categoryBitMask = PhysicsCategory.RedPlayer
        redPlayer.physicsBody?.collisionBitMask = PhysicsCategory.Ball | PhysicsCategory.BottomBoundary | PhysicsCategory.LeftBoundary | PhysicsCategory.RightBoundary | PhysicsCategory.TopBoundary | PhysicsCategory.Player
        redPlayer.physicsBody?.contactTestBitMask = PhysicsCategory.Ball | PhysicsCategory.Player
        redPlayer.physicsBody?.friction = 0.8
        redPlayer.physicsBody?.restitution = 0
        
        redPlayer.name = "redPlayer"
        
        addChild(redPlayer)
    }
    
    func moveRedPlayer() {
        
        let goalHeight1 = size.height * 0.11
        let goalWidth1 = size.width * 0.5
        let goalYPosition1 = size.height * 0.75
        let goalXMin1 = (size.width / 2) - goalWidth1 / 2
        let goalXMax1 = (size.width / 2) + goalWidth1 / 2
        let goalYMin1 = goalYPosition1 - goalHeight1 / 2 + 10
        let goalYMax1 = goalYPosition1 + goalHeight1 / 2 - 10

        let goalHeight2 = size.height * 0.11
        let goalWidth2 = size.width * 0.5
        let goalYPosition2 = size.height * 0.1
        let goalXMin2 = (size.width / 2) - goalWidth2 / 2
        let goalXMax2 = (size.width / 2) + goalWidth2 / 2
        let goalYMin2 = goalYPosition2 - goalHeight2 / 2 + 10
        let goalYMax2 = goalYPosition2 + goalHeight2 / 2 - 10
        
        guard let ball = childNode(withName: "ball") as? SKSpriteNode else {
            print("Мяч не найден!")
            return
        }
        
        let ballPosition = ball.position
        let redPlayerPosition = redPlayer.position
        
        // Вычисляем направление между игроком и мячом
        let direction = CGVector(dx: ballPosition.x - redPlayerPosition.x, dy: ballPosition.y - redPlayerPosition.y)
        
        // Нормализуем вектор для постоянного направления движения
        let normalizedDirection = direction.normalized()
        
        // Устанавливаем скорость игрока (чем меньше значение, тем плавнее движение)
        
        
        // Создаем вектор движения с применением скорости
        let moveVector = CGVector(dx: normalizedDirection.dx * moveSpeed * 0.01, dy: normalizedDirection.dy * moveSpeed * 0.01)
        
        // Новая позиция игрока
        let newPlayerPosition = CGPoint(x: redPlayerPosition.x + moveVector.dx, y: redPlayerPosition.y + moveVector.dy)
        
        // Проверка на попадание в границы
        let isInsideGoal1 = newPlayerPosition.x >= goalXMin1 && newPlayerPosition.x <= goalXMax1 &&
                            newPlayerPosition.y >= goalYMin1 && newPlayerPosition.y <= goalYMax1
        
        let isInsideGoal2 = newPlayerPosition.x >= goalXMin2 && newPlayerPosition.x <= goalXMax2 &&
                            newPlayerPosition.y >= goalYMin2 && newPlayerPosition.y <= goalYMax2
        
        // Если игрок не внутри любой из зон, обновляем его позицию
        if !isInsideGoal1 && !isInsideGoal2 {
            redPlayer.position = newPlayerPosition
        }
        
        // Поворот игрока к мячу
        let angle = atan2(direction.dy, direction.dx)
        let rotateAction = SKAction.rotate(toAngle: angle - CGFloat.pi / 2, duration: 0.1, shortestUnitArc: true)
        redPlayer.run(rotateAction)
    }




    
    private func addBorder() {
        let screenWidth = size.width
        let screenHeight = size.height
        
        let boundaryWidth: CGFloat = 10
        let boundaryHeight = screenHeight * 0.85
        let horizontalBoundaryHeight: CGFloat = 10
        
        let leftBoundary = SKShapeNode(rectOf: CGSize(width: boundaryWidth, height: boundaryHeight))
        leftBoundary.position = CGPoint(x: screenWidth*0.01, y: screenHeight*0.425)
        
        leftBoundary.fillColor = .clear
        leftBoundary.strokeColor = .clear
        
        let leftPhysicsBody = SKPhysicsBody(rectangleOf: CGSize(width: boundaryWidth, height: boundaryHeight))
        leftPhysicsBody.isDynamic = false
        leftPhysicsBody.categoryBitMask = PhysicsCategory.LeftBoundary
        leftPhysicsBody.collisionBitMask = PhysicsCategory.Ball | PhysicsCategory.Player
        leftPhysicsBody.friction = 0.2
        leftPhysicsBody.restitution = 0.8
        leftBoundary.physicsBody = leftPhysicsBody
        
        addChild(leftBoundary)
        
        let rightBoundary = SKShapeNode(rectOf: CGSize(width: boundaryWidth, height: boundaryHeight))
        rightBoundary.position = CGPoint(x: screenWidth*0.99, y: screenHeight*0.425)
        
        rightBoundary.fillColor = .clear
        rightBoundary.strokeColor = .clear
        
        let rightPhysicsBody = SKPhysicsBody(rectangleOf: CGSize(width: boundaryWidth, height: boundaryHeight))
        rightPhysicsBody.isDynamic = false
        rightPhysicsBody.categoryBitMask = PhysicsCategory.RightBoundary
        rightPhysicsBody.collisionBitMask = PhysicsCategory.Ball | PhysicsCategory.Player
        rightPhysicsBody.friction = 0.2
        rightPhysicsBody.restitution = 0.8
        rightBoundary.physicsBody = rightPhysicsBody
        
        addChild(rightBoundary)
        
        let topBoundary = SKShapeNode(rectOf: CGSize(width: screenWidth, height: horizontalBoundaryHeight))
        topBoundary.position = CGPoint(x: screenWidth / 2, y: screenHeight*0.84)
        
        let topPhysicsBody = SKPhysicsBody(rectangleOf: CGSize(width: screenWidth, height: horizontalBoundaryHeight))
        
        topBoundary.fillColor = .clear
        topBoundary.strokeColor = .clear

        topPhysicsBody.isDynamic = false
        topPhysicsBody.categoryBitMask = PhysicsCategory.TopBoundary
        topPhysicsBody.collisionBitMask = PhysicsCategory.Ball | PhysicsCategory.Player
        topPhysicsBody.friction = 0.5
        topPhysicsBody.restitution = 0.8
        topBoundary.physicsBody = topPhysicsBody
        
        addChild(topBoundary)
        
        let bottomBoundary = SKShapeNode(rectOf: CGSize(width: screenWidth, height: horizontalBoundaryHeight))
        bottomBoundary.position = CGPoint(x: screenWidth / 2, y: screenHeight*0.0001)
        
        let bottomPhysicsBody = SKPhysicsBody(rectangleOf: CGSize(width: screenWidth, height: horizontalBoundaryHeight))
        
        bottomBoundary.fillColor = .clear
        bottomBoundary.strokeColor = .clear
        
        bottomPhysicsBody.isDynamic = false
        bottomPhysicsBody.categoryBitMask = PhysicsCategory.BottomBoundary
        bottomPhysicsBody.collisionBitMask = PhysicsCategory.Ball | PhysicsCategory.Player
        bottomPhysicsBody.friction = 0.5
        bottomPhysicsBody.restitution = 0.8
        bottomBoundary.physicsBody = bottomPhysicsBody
        
        addChild(bottomBoundary)
        
    }
    
    func addMenuButton() {
        let screenWidth = size.width
        let screenHeight = size.height

        let topFieldHeight = screenHeight * 0.15
        
        let pauseButton = SKSpriteNode(imageNamed: "menuButton")
        pauseButton.name = "pauseButton"
        pauseButton.size = CGSize(width: 45, height: 45)
        pauseButton.position = CGPoint(x: screenWidth * 0.1, y: screenHeight - topFieldHeight / 2)
        addChild(pauseButton)
        
        
        infoButton.name = "infoButton"
        infoButton.size = CGSize(width: 45, height: 45)
        infoButton.position = CGPoint(x: screenWidth * 0.9, y: screenHeight - topFieldHeight / 2)
        addChild(infoButton)
    }
    
    func handleButtonPress() {
        
        if flagButton == true {
            flagButton = false
            // Останавливаем движение красного игрока
            moveSpeed = 0
            
            infoButton.color = .gray // Измените цвет, чтобы показать, что кнопка неактивна
            infoButton.colorBlendFactor = 1.0 // Делает цвет полностью непрозрачным
            
            // Запускаем таймер для восстановления скорости через 2 секунды
            let delayAction = SKAction.wait(forDuration: 2.0)
            let restoreSpeedAction = SKAction.run {
                self.moveSpeed = 175.0
            }
            
            let sequence = SKAction.sequence([delayAction, restoreSpeedAction])
            run(sequence)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let ballNode = (bodyA.categoryBitMask == PhysicsCategory.Ball) ? bodyA.node as? SKSpriteNode : (bodyB.categoryBitMask == PhysicsCategory.Ball) ? bodyB.node as? SKSpriteNode : nil
        
        let playerNode = (bodyA.categoryBitMask == PhysicsCategory.Player) ? bodyA.node as? SKSpriteNode : (bodyB.categoryBitMask == PhysicsCategory.Player) ? bodyB.node as? SKSpriteNode : nil
        
        let redPlayerNode = (bodyA.categoryBitMask == PhysicsCategory.RedPlayer) ? bodyA.node as? SKSpriteNode : (bodyB.categoryBitMask == PhysicsCategory.RedPlayer) ? bodyB.node as? SKSpriteNode : nil
        
        let goalBottomNode = (bodyA.categoryBitMask == PhysicsCategory.YouGoal) ? bodyA.node as? SKSpriteNode : (bodyB.categoryBitMask == PhysicsCategory.YouGoal) ? bodyB.node as? SKSpriteNode : nil
        
        let goalAIBottomNode = (bodyA.categoryBitMask == PhysicsCategory.AIGoal) ? bodyA.node as? SKSpriteNode : (bodyB.categoryBitMask == PhysicsCategory.AIGoal) ? bodyB.node as? SKSpriteNode : nil
        
        if let ball = ballNode {
            if let _ = goalBottomNode {
                youScore += 1
                label4.text = String(format: "%02d", youScore)
                
                checkForGameOver()
                ball.removeFromParent()
                player.removeFromParent()
                redPlayer.removeFromParent()
                
                addBall()
                addPlayer()
                addRedPlayer()
                
            } else if let player = playerNode {
                let playerPosition = player.position
                let ballPosition = ball.position
                
                let direction = CGVector(dx: ballPosition.x - playerPosition.x, dy: ballPosition.y - playerPosition.y)
                
                let normalizedDirection = direction.normalized()
                
                let impulseMagnitude: CGFloat = 5
                let impulse = CGVector(dx: normalizedDirection.dx * impulseMagnitude, dy: normalizedDirection.dy * impulseMagnitude)
                
                ball.physicsBody?.applyImpulse(impulse)
                
                let angularVelocity: CGFloat = 5
                ball.physicsBody?.angularVelocity = angularVelocity
            } else if let _ = goalAIBottomNode {
                aiScore += 1
                label6.text = String(format: "%02d", aiScore)
                

                checkForGameOver()
                ball.removeFromParent()
                player.removeFromParent()
                redPlayer.removeFromParent()
                
                addBall()
                addPlayer()
                addRedPlayer()
            } else if let player = redPlayerNode {
                let playerPosition = player.position
                let ballPosition = ball.position
                
                let direction = CGVector(dx: ballPosition.x - playerPosition.x, dy: ballPosition.y - playerPosition.y)
                
                let normalizedDirection = direction.normalized()
                
                let impulseMagnitude: CGFloat = 7
                let impulse = CGVector(dx: normalizedDirection.dx * impulseMagnitude, dy: normalizedDirection.dy * impulseMagnitude)
                
                ball.physicsBody?.applyImpulse(impulse)
                
                let angularVelocity: CGFloat = 5
                ball.physicsBody?.angularVelocity = angularVelocity
            }
        }
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gamePaused == false {
            guard let lastTouchPosition1 = lastTouchPosition else { return }
            
            for touch in touches {
                let currentTouchPosition = touch.location(in: self)
                
                // Разница между последним и текущим касанием
                let deltaX = currentTouchPosition.x - lastTouchPosition1.x
                let deltaY = currentTouchPosition.y - lastTouchPosition1.y
                
                let newPlayerX = player.position.x + deltaX
                let newPlayerY = player.position.y + deltaY
                
                let playerWidth = player.size.width
                let playerHeight = player.size.height
                
                // Определение границ ворот
                let goalHeight1 = size.height * 0.06
                let goalWidth1 = size.width * 0.41
                let goalYPosition1 = size.height * 0.75
                let goalXMin1 = (size.width / 2) - goalWidth1 / 2
                let goalXMax1 = (size.width / 2) + goalWidth1 / 2
                let goalYMin1 = goalYPosition1 - goalHeight1 / 2
                let goalYMax1 = goalYPosition1 + goalHeight1 / 2
                
                let goalHeight2 = size.height * 0.06
                let goalWidth2 = size.width * 0.41
                let goalYPosition2 = size.height * 0.1
                let goalXMin2 = (size.width / 2) - goalWidth2 / 2
                let goalXMax2 = (size.width / 2) + goalWidth2 / 2
                let goalYMin2 = goalYPosition2 - goalHeight2 / 2
                let goalYMax2 = goalYPosition2 + goalHeight2 / 2
                
                let playerXMin = newPlayerX - playerWidth / 2
                let playerXMax = newPlayerX + playerWidth / 2
                let playerYMin = newPlayerY - playerHeight / 2
                let playerYMax = newPlayerY + playerHeight / 2
                
                let insideGoal1 = playerXMin < goalXMax1 && playerXMax > goalXMin1 &&
                playerYMin < goalYMax1 && playerYMax > goalYMin1
                
                let insideGoal2 = playerXMin < goalXMax2 && playerXMax > goalXMin2 &&
                playerYMin < goalYMax2 && playerYMax > goalYMin2
                
                if !insideGoal1 && !insideGoal2 {
                    player.position = CGPoint(x: newPlayerX, y: newPlayerY)
                }
                
                lastTouchPosition = currentTouchPosition
            }
        }
    }
    
    func checkForGameOver() {
            if youScore >= targetGoal {
                GameData.shared.youScore = self.youScore
                GameData.shared.aiScore = self.aiScore
                GameData.shared.time = self.timeLeft
                gameOver()
            }
        }
        
        func gameOver() {
            
            self.isPaused = true
            self.isUserInteractionEnabled = false
            t = 0
            
            if let currentViewController = self.view?.window?.rootViewController?.presentedViewController ?? self.view?.window?.rootViewController {
                if youScore >= aiScore && youScore == targetGoal{
                    let winController = WinViewController()
                    winController.modalPresentationStyle = .overFullScreen
                    currentViewController.present(winController, animated: true, completion: nil)
                } else {
                    let loseController = LoseViewController()
                    loseController.modalPresentationStyle = .overFullScreen
                    currentViewController.present(loseController, animated: true, completion: nil)
                }
            }

            
        }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }

    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if gamePaused == false {
            moveRedPlayer()
            guard let ball = childNode(withName: "ball") as? SKSpriteNode else {
                print("Мяч не найден!")
                return
            }
            
            // Позиции игрока и мяча
            let playerPosition = player.position
            let ballPosition = ball.position
            
            // Вычисляем направление между игроком и мячом
            let dx = ballPosition.x - playerPosition.x
            let dy = ballPosition.y - playerPosition.y
            
            // Вычисляем угол
            let angle = atan2(dy, dx)
            
            // Создаем действие вращения
            let rotateAction = SKAction.rotate(toAngle: angle - CGFloat.pi / 2, duration: 0.1, shortestUnitArc: true)
            
            // Запускаем действие на игроке
            player.run(rotateAction)
            
            
            let screenWidth = size.width
            let screenHeight = size.height
            
            let playerWidth = player.size.width
            let playerHeight = player.size.height
            
            // Границы экрана, учитывая размеры игрока
            let boundaryLeft = playerWidth / 2
            let boundaryRight = screenWidth - playerWidth / 2
            
            let topBoundaryHeight: CGFloat = 10 // Высота верхней границы (из вашего кода)
            let topBoundaryPositionY = screenHeight * 0.85 // Позиция верхней границы по оси Y
            let boundaryTop = topBoundaryPositionY + topBoundaryHeight / 2 - playerHeight / 2
            
            let boundaryBottom = playerHeight / 2
            
            if player.position.x < boundaryLeft {
                player.position.x = boundaryLeft
            } else if player.position.x > boundaryRight {
                player.position.x = boundaryRight
            }
            
            if player.position.y < boundaryBottom {
                player.position.y = boundaryBottom
            } else if player.position.y > boundaryTop {
                player.position.y = boundaryTop
            }
            
            
            if ball.position.x < boundaryLeft-40 || ball.position.x > boundaryRight+40 || ball.position.y < boundaryBottom-40 || ball.position.y > boundaryTop+40 {
                ball.position = CGPoint(x: screenWidth / 2, y: screenHeight * 0.425)
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            lastTouchPosition = location
            
            if node.name == "infoButton" {
                if gamePaused == false {
                    handleButtonPress()
                }
            }
            if node.name == "pauseButton"{
                if gamePaused {
                    t = 1
                    gamePaused = false
                    self.isPaused = false
                    self.isUserInteractionEnabled = true
                } else {
                    t = 0
                    gamePaused = true
                    self.isPaused = true
                    self.isUserInteractionEnabled = true
                }
                
            }
        }
    }

}

extension CGVector {
    func normalized() -> CGVector {
        let length = sqrt(dx * dx + dy * dy)
        return length > 0 ? CGVector(dx: dx / length, dy: dy / length) : CGVector(dx: 0, dy: 0)
    }
}

struct PhysicsCategory {
    static let Player: UInt32 = 0x1 << 0
    static let Ball: UInt32 = 0x1 << 1
    static let TopBoundary: UInt32 = 0x1 << 2
    static let BottomBoundary: UInt32 = 0x1 << 3
    static let LeftBoundary: UInt32 = 0x1 << 4
    static let RightBoundary: UInt32 = 0x1 << 5
    static let YouGoal: UInt32 = 0x1 << 6
    static let TopBoundary1: UInt32 = 0x1 << 7
    static let LeftBoundary1: UInt32 = 0x1 << 9
    static let RightBoundary1: UInt32 = 0x1 << 10
    static let AIGoal: UInt32 = 0x1 << 11
    static let TopBoundary2: UInt32 = 0x1 << 12
    static let LeftBoundary2: UInt32 = 0x1 << 14
    static let RightBoundary2: UInt32 = 0x1 << 15
    static let RedPlayer: UInt32 = 0x1 << 16
}
