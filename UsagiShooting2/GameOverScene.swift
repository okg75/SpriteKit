//
//  GameOverScene.swift
//  UsagiShooting2
//
//  Created by okg75 on 2018/10/04.
//  Copyright © 2018年 stu75. All rights reserved.
//

import SpriteKit

/// ゲームオーバー
class GameOverScene: SKScene {

    /// スコア
    var score = 0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .black
        
        // ゲームオーバー
        let gameoverNode = SKLabelNode(text: "GameOver")
        gameoverNode.name = "title"
        gameoverNode.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height/4*3)
        gameoverNode.fontColor = .red
        gameoverNode.fontSize = 32
        addChild(gameoverNode)
        
        // リトライボタン
        let retryNode = SKLabelNode(text: "リトライ")
        retryNode.name = "retry"
        retryNode.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height/3)
        retryNode.fontColor = .yellow
        retryNode.fontSize = 20
        addChild(retryNode)
        
        // スコア
        let scoreNode = SKLabelNode(text: "スコア：\(score)")
        scoreNode.name = "score"
        scoreNode.position = CGPoint(x: view.bounds.width/2, y: retryNode.frame.maxY + 30)
        scoreNode.fontColor = .white
        scoreNode.fontSize = 20
        addChild(scoreNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else {
            return
        }
        
        let location =  t.location(in: self)
        // タッチした箇所にあるノードがretryの場合は画面遷移
        if nodes(at: location).first?.name == "retry" {
            let nextScene = GameScene(size: scene!.size)
            nextScene.scaleMode = .aspectFill
            view?.presentScene(nextScene)
        }
    }
}
