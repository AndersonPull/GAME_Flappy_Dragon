//
//  GameScene.swift
//  FlappyDragon
//
//  Created by Anderson Oliveira on 20/04/19.
//  Copyright © 2019 Anderson Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var caminho: SKSpriteNode!
    var intro: SKSpriteNode!
    var player: SKSpriteNode!
    var areaDoJogo: CGFloat = 410.0
    var velocidade: Double = 100.0
    var inicioDoJogo = false
    var fimDeJogo = false
    var restart = false
    var lblScore: SKLabelNode!
    var score: Int = 0
    var forca: CGFloat = 30.0
    var CategoriaPlayer: UInt32 = 1
    var CategoriaInimigo: UInt32 = 2
    var CategoriaScore: UInt32 = 4
    var timer: Timer!
    var scoreSound = SKAction.playSoundFileNamed("score.mp3", waitForCompletion: false)
    var gameOverSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    weak var gameViewController: GameViewController?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        addBackground()
        addCaminho()
        addIntro()
        addPlayer()
    }
    
    func addBackground(){
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    func addCaminho(){
        caminho = SKSpriteNode(imageNamed: "floor")
        caminho.zPosition = 2
        caminho.position = CGPoint(x: caminho.size.width/2, y: size.height - areaDoJogo - caminho.size.height/2)
        addChild(caminho)
        
        let duracao = Double(caminho.size.width/2)/velocidade
        let moverAcao = SKAction.moveBy(x: -caminho.size.width/2, y: 0, duration: duracao)
        let resetXAction = SKAction.moveBy(x: caminho.size.width/2, y: 0, duration: 0)
        let SequenciaAcao = SKAction.sequence([moverAcao, resetXAction])
        let repetirAcao = SKAction.repeatForever(SequenciaAcao)
        
        let caminhoInvisivel = SKNode()
        caminhoInvisivel.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        caminhoInvisivel.physicsBody?.isDynamic = false
        caminhoInvisivel.position = CGPoint(x: size.width/2, y: size.height - areaDoJogo)
        caminhoInvisivel.zPosition = 2
        caminhoInvisivel.physicsBody?.categoryBitMask = CategoriaInimigo
        caminhoInvisivel.physicsBody?.contactTestBitMask = CategoriaPlayer
        addChild(caminhoInvisivel)
        
        let tetoInvisivel = SKNode()
        tetoInvisivel.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        tetoInvisivel.physicsBody?.isDynamic = false
        tetoInvisivel.position = CGPoint(x: size.width/2, y: size.height - areaDoJogo)
        tetoInvisivel.zPosition = 2
        addChild(tetoInvisivel)
        
        caminho.run(repetirAcao)
    }
    
    func addIntro(){
        intro = SKSpriteNode(imageNamed: "intro")
        intro.zPosition = 2
        intro.position = CGPoint(x: size.width/2, y: size.height - 210)
        addChild(intro)
    }
    
    func addPlayer(){
        
        player = SKSpriteNode(imageNamed: "player1")
        player.zPosition = 4
        player.position = CGPoint(x: 70, y: size.height - areaDoJogo/2)
        addChild(player)
        
        var playerCenas = [SKTexture]()
        for i in 1...4 {
            playerCenas.append(SKTexture(imageNamed: "player\(i)"))
        }
        let animacaoAcao = SKAction.animate(with: playerCenas, timePerFrame: 0.09)
        let repitirAcao = SKAction.repeatForever(animacaoAcao)
        player.run(repitirAcao)
    }
    func addScore(){
        lblScore = SKLabelNode(fontNamed: "Chalkduster")
        lblScore.fontSize = 94
        lblScore.text = "\(score)"
        lblScore.position = CGPoint(x: size.width/2, y: size.height - 100)
        lblScore.zPosition = 5
        lblScore.alpha = 0.8
        addChild(lblScore)
    }
    
    func inimigos(){
        let posicaoInicial = CGFloat(arc4random_uniform(132) + 74)
        let inimigos =  Int(arc4random_uniform(4) + 1)
        let distanciaDoInimigo = self.player.size.height * 2.5
        
        let inimigoTopo = SKSpriteNode(imageNamed: "enemytop\(inimigos)")
        let inimigoWidth = inimigoTopo.size.width
        let inimigoHeight = inimigoTopo.size.height
        
        inimigoTopo.position = CGPoint(x: size.width + inimigoWidth/2, y: size.height - posicaoInicial + inimigoHeight/2)
        inimigoTopo.zPosition = 1
        inimigoTopo.physicsBody = SKPhysicsBody(rectangleOf: inimigoTopo.size)
        inimigoTopo.physicsBody?.isDynamic = false
        inimigoTopo.physicsBody?.categoryBitMask = CategoriaInimigo
        inimigoTopo.physicsBody?.contactTestBitMask = CategoriaPlayer
        
        let inimigoTBotom = SKSpriteNode(imageNamed: "enemybottom\(inimigos)")
        inimigoTBotom.position = CGPoint(x: size.width + inimigoWidth/2, y: inimigoTopo.position.y - inimigoTopo.size.height - distanciaDoInimigo)
        inimigoTBotom.zPosition = 1
        inimigoTBotom.physicsBody = SKPhysicsBody(rectangleOf: inimigoTBotom.size)
        inimigoTBotom.physicsBody?.isDynamic = false
        
        let laser = SKNode()
      
        
        let distancia = size.width + inimigoWidth
        let duracao = Double(distancia)/velocidade
        let moverAcao = SKAction.moveBy(x: -distancia, y: 0, duration: duracao)
        let removerAcao = SKAction.removeFromParent()
        let sequeciaDaAcao = SKAction.sequence([moverAcao, removerAcao])
        inimigoTopo.run(sequeciaDaAcao)
        inimigoTBotom.run(sequeciaDaAcao)
        inimigoTBotom.physicsBody?.categoryBitMask = CategoriaInimigo
        inimigoTBotom.physicsBody?.contactTestBitMask = CategoriaPlayer
        
        laser.position = CGPoint(x: inimigoTopo.position.x + inimigoWidth/2, y:  inimigoTopo.position.y - inimigoTopo.size.height/2 - distanciaDoInimigo/2)
        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: distanciaDoInimigo))
        laser.physicsBody?.isDynamic = false
        laser.physicsBody?.categoryBitMask = CategoriaScore
        
        laser.run(sequeciaDaAcao)
        
        addChild(inimigoTopo)
        addChild(inimigoTBotom)
        addChild(laser)
        
    }
    
    func gameOver(){
        timer.invalidate()
        player.zRotation = 0
        player.texture = SKTexture(imageNamed: "playerDead")
        for node in self.children{
            node.removeAllActions()
        }
        player.physicsBody?.isDynamic = false
        fimDeJogo = true
        inicioDoJogo = false
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) {  (Timer) in
            let lblGameOver = SKLabelNode(fontNamed: "Chalkduster")
            lblGameOver.fontColor = .red
            lblGameOver.fontSize = 40
            lblGameOver.text = "GAME OVER"
            lblGameOver.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            lblGameOver.zPosition = 5
            self.addChild(lblGameOver)
            self.restart = true
            
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !fimDeJogo{
            if !inicioDoJogo{
                intro.removeFromParent()
                addScore()
                
                player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2 - 10)
                player.physicsBody?.isDynamic = true
                player.physicsBody?.allowsRotation = true
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: forca))
                player.physicsBody?.categoryBitMask = CategoriaPlayer
                player.physicsBody?.contactTestBitMask = CategoriaScore
                player.physicsBody?.collisionBitMask = CategoriaInimigo
                inicioDoJogo = true
            
                timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true, block: { (Timer) in
                    self.inimigos()
                })
            }else{
                player.physicsBody?.velocity = CGVector.zero
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: forca))
            }
        }
        else{
            if restart{
                restart = false
                gameViewController?.mostrarCena()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if inicioDoJogo{
            let yVelocidade = player.physicsBody!.velocity.dy * 0.001 as CGFloat
            player.zRotation = yVelocidade
        }
    }
}


extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        if inicioDoJogo{
            if contact.bodyA.categoryBitMask == CategoriaScore || contact.bodyB.categoryBitMask == CategoriaScore{
                score += 1
                lblScore.text = "\(score)"
                run(scoreSound)
            }
            else if contact.bodyA.categoryBitMask == CategoriaInimigo || contact.bodyB.categoryBitMask == CategoriaInimigo{
                gameOver()
                run(gameOverSound)
            }
            
        }
    }
    
}

