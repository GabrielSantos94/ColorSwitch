//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Gabriel Jesus Santos on 17/05/21.
//

import SpriteKit

//MARK: - enum

enum PlayColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchState: Int {
    case red, yellow, green, blue
}

class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    //MARK: - Override methods
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
    
    //MARK: - setupPhysics method
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
    }
    
    //MARK: - layoutScene method
    
    func layoutScene() {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false // impede que qualquer força mova o objeto, incluindo a gravidade
        
        addChild(colorSwitch)
        
        setupScoreLabel()
        spawnBall()
    }
    
    func setupScoreLabel() {
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        
        addChild(scoreLabel)
    }
    
    func spawnBall() {
        currentColorIndex = Int(arc4random_uniform(UInt32(4))) // cria um número aleatório entre 0 e 3
        
        let ball = SKSpriteNode(
            texture: SKTexture(imageNamed: "ball"),
            color: PlayColors.colors[currentColorIndex!],
            size: CGSize(width: 30, height: 30)
        )
        ball.colorBlendFactor = 1 //garante que a cor seja aplicada à textura
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(ball)
    }
    
    //MARK: - turn color wheel method
    
    func turnWheel() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
        } else {
            switchState = .red
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    //MARK: - game over method
    
    func gameOver() {
        
        //salvar a pontuação
        UserDefaults.standard.set(score, forKey: "RecentScore")
        
        if score > UserDefaults.standard.integer(forKey: "Highscore") {
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)
    }
    
    //MARK: - updateLabel method
    
    func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }
}

//MARK: - extension SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
    
    // Esse metodo é disparado quando os objetos se colidem na cena
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode :
                contact.bodyB.node as? SKSpriteNode {
                
                //verifica se o index da cor escolhida faz match com o index do array de cores
                if currentColorIndex == switchState.rawValue {
                    score += 1
                    updateScoreLabel()
                    ball.run(SKAction.fadeOut(withDuration: 0.25)) { [weak self] in
                        ball.removeFromParent() // remove a bola antiga da cena
                        self?.spawnBall()
                    }
                } else {
                    gameOver()
                }
            }
        }
    }
}
