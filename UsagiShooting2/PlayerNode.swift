//
//  playerNode.swift
//  UsagiShooting2
//
//  Created by okg75 on 2018/09/26.
//  Copyright © 2018年 stu75. All rights reserved.
//

import SpriteKit

// プレイヤーが発射する弾丸ノード
class PlayerNode: SKSpriteNode {
    
    var life: Int
    private var unusedEnemyBullet: [SKNode] = []
    private var bulletTimer: Timer?

    init() {
        life = 3
        super.init(texture: SKTexture(imageNamed: "player"),
                   color: .clear,
                   size: CGSize(width: 80, height: 80))
        name = "player"

        // プレイヤーの当たり判定を可視化
        let centerCircle = SKShapeNode(circleOfRadius: 6)
        centerCircle.fillColor = .magenta
        centerCircle.position = CGPoint(x: centerCircle.position.x, y: centerCircle.position.y-16)
        addChild(centerCircle)

        // 物理シミュレーションをするオブジェクトを作成する
        physicsBody = SKPhysicsBody(circleOfRadius: 6)
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = Category.player
        physicsBody?.collisionBitMask = Category.enemyBullet
        physicsBody?.contactTestBitMask = Category.enemyBullet

        // 弾を発射する
        bulletTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in self.shoot()}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot() {
        let bullet = PlayerBullet.normal
        bullet.shoot(scene: self.scene, playerPos: self.position)
    }
    
    func hit(bullet: SKNode, block: (Bool) -> Void) {
        var isRemovedPlayer = false
        if unusedEnemyBullet.contains(bullet) == false {
            unusedEnemyBullet.append(bullet)
            // 敵と衝突したら弾を削除する
            bullet.removeFromParent()
            life -= 1
            // ライフが0になったら自身を削除する
            if life == 0 {
                bulletTimer?.invalidate()
                removeFromParent()
                isRemovedPlayer = true
            }
        }
        block(isRemovedPlayer)
    }
}

// プレイヤーの発射する弾丸を定義する
enum PlayerBullet {
    case normal
    
    /// 弾丸
    private var bullet: SKSpriteNode {
        let imageName: String
        let size: CGSize
        switch self {
        case .normal:
            imageName = "bullet"
            size = CGSize(width: 16, height: 16)
        }
        let bullet = SKSpriteNode(texture: SKTexture(imageNamed: imageName),
                                  color: .clear,
                                  size: size)
        bullet.name = "playerBullet"
        bullet.physicsBody = SKPhysicsBody(rectangleOf: size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.allowsRotation = false
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = Category.playerBullet
        bullet.physicsBody?.contactTestBitMask = Category.enemy
        bullet.physicsBody?.collisionBitMask = Category.enemy
        return bullet
    }
    
    /// アクション
    private func getAction(playerPos: CGPoint) -> SKAction {
        switch self {
        case .normal:
            return SKAction.sequence([
                SKAction.moveTo(y: UIScreen.main.bounds.size.height + playerPos.y, duration: 1.0),
                SKAction.removeFromParent()])
        }
    }
    
    /// 撃つ
    ///
    /// - Parameters:
    ///   - scene: シーン
    ///   - playerPos: プレイヤーの位置
    func shoot(scene: SKScene?, playerPos: CGPoint) {
        let b = self.bullet
        b.position = playerPos
        b.run(getAction(playerPos: playerPos))
        scene?.addChild(b)
    }
}

