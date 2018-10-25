//
//  Calc.swift
//  UsagiShooting2
//
//  Created by okg75 on 2018/10/05.
//  Copyright © 2018年 stu75. All rights reserved.
//

import Foundation

class Calc {
    static func random(min: UInt32, max: UInt32) -> UInt32 {
        // ランダムな数値の範囲を指定できないため,
        // 最低値を最初に引いておいて最後にプラスする
        return arc4random_uniform(max-min) + min
    }
}
