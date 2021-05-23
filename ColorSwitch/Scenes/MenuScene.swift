//
//  MenuScene.swift
//  ColorSwitch
//
//  Created by Gabriel Jesus Santos on 17/05/21.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        addLogo()
        addLabels()
    }
    
    func addLogo() {
        
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.size = CGSize(width: frame.size.width / 4, height: frame.size.width / 4)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height / 4)
        
        addChild(logo)
    }
    
    func addLabels() {
        let playLabel = SKLabelNode(text: "Clique para Jogar!")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 30.0
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)

        addChild(playLabel)
        animate(label: playLabel)
        
        let pontuação = UserDefaults.standard.integer(forKey: "Highscore")
        let highsScoreLabel = SKLabelNode(text: "Pontuação: \(pontuação)")
        highsScoreLabel.fontName = "AvenirNext-Bold"
        highsScoreLabel.fontSize = 20.0
        highsScoreLabel.fontColor = UIColor.white
        highsScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - highsScoreLabel.frame.size.height * 4)
        
        addChild(highsScoreLabel)
        
        let pontoRecente = UserDefaults.standard.integer(forKey: "RecentScore")
        let recentScoreLabel = SKLabelNode(text: "Pontos recentes: \(pontoRecente)")
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.fontSize = 20.0
        recentScoreLabel.fontColor = UIColor.white
        recentScoreLabel.position = CGPoint(x: frame.midX, y: highsScoreLabel.position.y - recentScoreLabel.frame.size.height * 2)
        
        addChild(recentScoreLabel)
    }
    
    func animate(label: SKLabelNode) {
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        
        label.run(SKAction.repeatForever(sequence))
    }
}

//MARK:- Extension touchesBegan

extension MenuScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
}
