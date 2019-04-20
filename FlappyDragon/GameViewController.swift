//
//  GameViewController.swift
//  FlappyDragon
//
//  Created by Anderson Oliveira on 20/04/19.
//  Copyright © 2019 Anderson Oliveira. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var stage: SKView!
    var gameSound: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stage = view as! SKView
        stage.ignoresSiblingOrder = true
        
        mostrarCena()
        playMusic()
    }

    func mostrarCena(){
        let cena = GameScene(size: CGSize(width: 320, height: 568))
        cena.gameViewController = self
        cena.scaleMode = .aspectFill
        stage.presentScene(cena, transition: .doorway(withDuration: 0.5))
    }
    
    func playMusic(){
        if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a"){
            gameSound = try! AVAudioPlayer(contentsOf: musicURL)
            gameSound.numberOfLoops = -1
            gameSound.volume = 0.4
            gameSound.play()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
