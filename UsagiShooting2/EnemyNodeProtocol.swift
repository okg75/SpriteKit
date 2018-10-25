//
//  EnemyNode.swift
//  UsagiShooting2
//
//  Created by okg75 on 2018/09/28.
//  Copyright © 2018年 stu75. All rights reserved.
//

import SpriteKit

protocol EnemyNodeProtocol {
    /// 初期化
    init(startPos: CGPoint)
    /// ライフ
    var life: Int { get set }
    /// ポイント
    var point: Int { get }
    /// アクション開始する
    func startAction()
    /// 弾が当たった時の挙動
    func hit(bullet: SKNode, block: (Bool) -> Void)
}
