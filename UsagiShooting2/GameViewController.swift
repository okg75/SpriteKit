//
//  GameViewController.swift
//  UsagiShooting2
//
//  Created by okg75 on 2018/08/26.
//  Copyright © 2018年 stu75. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var skView: SKView {
        return view as! SKView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = SKView(frame: view.frame)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let scene = OpeningScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
