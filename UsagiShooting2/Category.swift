//
//  Category.swift
//  UsagiShooting2
//
//  Created by okg75 on 2018/10/07.
//  Copyright © 2018年 stu75. All rights reserved.
//

import Foundation

/// 衝突判定に使用するカテゴリ
class Category {
    /// プレイヤー
    public static let player: UInt32 = 0x1 << 1
    /// プレイヤー弾
    public static let playerBullet: UInt32 = 0x1 << 2
    /// 敵
    public static let enemy: UInt32 = 0x1 << 3
    /// 敵彈
    public static let enemyBullet: UInt32 = 0x1 << 4
}
