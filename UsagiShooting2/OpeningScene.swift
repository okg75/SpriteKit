//
//  StartScene.swift
//  UsagiShooting2
//
//  Created by okg75 on 2018/10/04.
//  Copyright © 2018年 stu75. All rights reserved.
//

import SpriteKit

class OpeningScene: SKScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .black

        // タイトル
        let titleNode = SKLabelNode(text: "うさぎシューティング")
        titleNode.name = "title"
        titleNode.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height/4*3)
        titleNode.fontColor = .white
        titleNode.fontSize = 32
        addChild(titleNode)
        
        // スタートボタン
        let startNode = SKLabelNode(text: "スタート")
        startNode.name = "start"
        startNode.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height/3)
        startNode.fontColor = .yellow
        startNode.fontSize = 20
        addChild(startNode)
        
        // アプリバージョン
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let versionNode = SKLabelNode(text: "v\(appVersion)")
        versionNode.name = "version"
        versionNode.position = CGPoint(x: view.bounds.width-50, y: 15)
        versionNode.fontColor = .white
        versionNode.fontSize = 20
        addChild(versionNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else {
            return
        }
        
        let location =  t.location(in: self)
        // タッチした箇所にあるノードがstartの場合は画面遷移
        if nodes(at: location).first?.name == "start" {
            let nextScene = GameScene(size: scene!.size)
            nextScene.scaleMode = .aspectFill
            view?.presentScene(nextScene)
        }
    }
}
