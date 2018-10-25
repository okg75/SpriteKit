//
//  RedEnemy.swift
//  UsagiShooting2
//
//  Created by okg75 on 2018/09/29.
//  Copyright © 2018年 stu75. All rights reserved.
//

import SpriteKit

// 360度弾を飛ばしてくる敵
class RedEnemy: SKSpriteNode, EnemyNodeProtocol {
    /// ライフ
    var life: Int
    /// この敵を倒したときにもらえるポイント
    var point: Int {
        return 10
    }
    /// 衝突判定済みのプレイヤー弾を保存する
    var unusedPlayerBullet: [SKNode] = []
    /// 弾を自動発射するためのタイマー
    var bulletTimer: Timer?
    
    required init(startPos: CGPoint) {
        self.life = 3
        let enemyTexture = SKTexture(imageNamed: "enemy")
        super.init(texture: enemyTexture,
                   color: .clear,
                   size: CGSize(width: 80, height: 80))
        position = startPos
        name = "enemy"
        
        // テクスチャのアルファ値が透明でないところに合わせて当たり判定がつく（パフォーマンスはあまり良くない）
        physicsBody = SKPhysicsBody(texture: enemyTexture,
                                    size: CGSize(width: 80,
                                                 height: 80))
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = Category.enemy
        physicsBody?.collisionBitMask =  Category.playerBullet
        physicsBody?.contactTestBitMask = Category.playerBullet
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAction() {
        let randomY = arc4random_uniform(UInt32(150)) + 20
        run(SKAction.moveTo(y: UIScreen.main.bounds.height - CGFloat(randomY), duration: 0.5))
        bulletTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in self.shoot() }
    }
    
    func shoot() {
        // 弾幕が移動する半径を画面の縦の長さとする
        let r = Double(UIScreen.main.bounds.height)
        // 弾の大きさ
        let circleOfRadius: CGFloat = 12
        
        for i in 0..<360 where i % 20 == 0 {
            let bullet = SKShapeNode(circleOfRadius: circleOfRadius)
            bullet.name = "enemyBullet"
            bullet.fillColor = .red
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: circleOfRadius)
            bullet.physicsBody?.affectedByGravity = false
            bullet.physicsBody?.allowsRotation = false
            bullet.physicsBody?.isDynamic = true
            bullet.physicsBody?.categoryBitMask = Category.enemyBullet
            bullet.physicsBody?.contactTestBitMask = Category.player
            bullet.physicsBody?.collisionBitMask = Category.player
            
            
            bullet.position = position
            let x = cos(.pi/180*Double(i))*r
            let y = sin(.pi/180*Double(i))*r
            
            let action = SKAction.sequence([
                SKAction.move(to: CGPoint(x: -x, y: -y), duration: 6.0),
                SKAction.removeFromParent()])
            
            bullet.run(action)
            scene?.addChild(bullet)
        }
    }
    
    func hit(bullet: SKNode, block: (Bool) -> Void) {
        var isRemovedEnemy = false
        if unusedPlayerBullet.contains(bullet) == false {
            unusedPlayerBullet.append(bullet)
            // 敵と衝突したら弾を削除する
            bullet.removeFromParent()
            life -= 1
            // ライフが0になったら敵を削除する
            if life == 0 {
                bulletTimer?.invalidate()
                removeFromParent()
                isRemovedEnemy = true
            }
        }
        block(isRemovedEnemy)
    }
}
