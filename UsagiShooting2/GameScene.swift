//
//  BattleScene.swift
//  UsagiShooting2
//
//  Created by okg75 on 2018/09/10.
//  Copyright © 2018年 stu75. All rights reserved.
//

import SpriteKit

/// 戦闘シーン
class GameScene: SKScene {

    /// プレイヤー
    var player: PlayerNode?
    /// スコア表示
    var scoreLabel: SKLabelNode?
    /// ライフ表示
    var lifeLabel: SKLabelNode?

    /// タッチ開始位置を保持する
    var touchBeginPos: CGPoint?
    /// タッチ開始した時のプレイヤーの位置を保持する
    var touchBeginPlayerPos: CGPoint?
    /// スコア
    var score: Int = 0

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .yellow
        
        // 衝突判定をする処理をGameScene内で行えるようにする
        physicsWorld.contactDelegate = self
        
        // プレイヤー
        player = PlayerNode()
        player?.position = CGPoint(x: view.frame.width/2,
                                   y: view.frame.height/3)
        addChild(player!)

        // スコアを表示する
        scoreLabel = SKLabelNode()
        addScore(point: 0)
        scoreLabel?.position = CGPoint(x: size.width-100,
                                       y: size.height-30)
        scoreLabel?.color = .white
        scoreLabel?.fontSize = 20
        scoreLabel?.fontColor = .black
        addChild(scoreLabel!)
        
        // プレイヤーのライフを表示する
        lifeLabel = SKLabelNode()
        lifeLabel?.position = CGPoint(x: 60, y: size.height-30)
        lifeLabel?.fontSize = 20
        setLife(lifePoint: player?.life ?? 0)
        addChild(lifeLabel!)

        // 最初の敵を呼ぶ
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            self.callEnemy()
        }
    }
    
    // タッチ開始した時に呼び出される
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            // プレイヤーの最初の位置を保持する
            touchBeginPos = t.location(in: self)
            // 最初のタッチした場所を取得する
            touchBeginPlayerPos = player?.position
        }
    }
    
    // タッチポイントが移動した時に呼び出される
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let baseTouchPos = touchBeginPos,
            let basePlayerPos = touchBeginPlayerPos else {
            return
        }
        for t in touches {
            let pos = t.location(in: self)
            // 画面の範囲を取得
            let screenRangeX = 1..<Double(view!.frame.width)
            let screenRangeY = 1..<Double(view!.frame.height)
            // スワイプした分だけヒーローを動かす
            // 移動した結果, 画面の外に出てしまう場合は変更なし
            var playerPosX = basePlayerPos.x - (baseTouchPos.x - pos.x)
            if !screenRangeX.contains(Double(playerPosX)) {
                playerPosX = player!.position.x
            }
            var playerPosY = basePlayerPos.y - (baseTouchPos.y - pos.y)
            if !screenRangeY.contains(Double(playerPosY)) {
                playerPosY = player!.position.y
            }
            // 移動
            player?.position = CGPoint(x: playerPosX,
                                       y: playerPosY)
        }
    }

    /// スコアを追加する
    ///
    /// - Parameter point: 取得したポイント
    func addScore(point: Int) {
        score += point
        scoreLabel?.text = String(format: "スコア：%d", score)
    }
    
    /// 現在のライフを表示する
    ///
    /// - Parameter life: ライフポイント
    private func setLife(lifePoint: Int) {
        guard lifePoint > 0 else {
            lifeLabel?.text = ""
            return
        }
        
        var lifeStr = ""
        for _ in 0..<lifePoint {
            lifeStr += "❤️"
        }
        lifeLabel?.text = lifeStr
    }
    
    /// 次の敵を呼ぶ
    private func callEnemy() {
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        // 出現数（1-3体）
        let appearCount = Calc.random(min: 1, max: 3)
        for _ in 0..<appearCount {
            // 出現するwidth. 端っこすぎると打てないのでmin/maxを少し余白を持たせている
            let appearWidth = Calc.random(min: 40, max: UInt32(width-40))
            // 敵を作成
            let enemy = RedEnemy(startPos: CGPoint(x: CGFloat(appearWidth), y: height + 40))
            addChild(enemy)
            enemy.startAction()
        }
    }
}

/// 衝突判定ロジックを行う
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 衝突判定時, 各NodeはbodyA・bodyBどちらにも入ってくる可能性があるため
        // カテゴリの値の低い方をfirstBodyに入れて最初に固定しておく
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 敵にプレイヤーの弾が当たった場合
        if  firstBody.categoryBitMask == Category.playerBullet
            && secondBody.categoryBitMask == Category.enemy {
            
            if let enemy = contact.bodyA.node as? EnemyNodeProtocol,
                let playerBullet = firstBody.node {
                
                // 敵に弾が当たった時の処理を実行する
                enemy.hit(bullet: playerBullet) { isRemoved in
                    
                    if isRemoved {
                        // 本ノードが削除された場合はスコアを追加する
                        addScore(point: enemy.point)

                        // 画面上から敵ノードがなくなったら次の敵を呼ぶ
                        if nil == childNode(withName: "enemy") {
                            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                                self.callEnemy()
                            }
                        }
                    }
                }
            }
            return
        }
        
        // プレイヤーに敵の弾が当たった場合
        if firstBody.categoryBitMask == Category.player
            && secondBody.categoryBitMask == Category.enemyBullet {

            // 弾を削除する
            contact.bodyB.node?.removeFromParent()
            if let player = contact.bodyA.node as? PlayerNode,
                let enemyBullet = secondBody.node {

                // プレイヤーに弾が当たった時の処理を実行する
                player.hit(bullet: enemyBullet) { isRemoved in
                    // ライフの表示を変更する
                    setLife(lifePoint: player.life)

                    if isRemoved {
                        // シーンからプレイヤーノードが削除された（ゲームオーバー）
                        let gameoverScene = GameOverScene(size: self.size)
                        gameoverScene.score = self.score
                        gameoverScene.scaleMode = .aspectFill
                        self.view?.presentScene(gameoverScene)
                    }
                }
            }
        }
    }
}
