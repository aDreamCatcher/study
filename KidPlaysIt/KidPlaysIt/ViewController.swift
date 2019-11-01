//
//  ViewController.swift
//  KidPlaysIt
//
//  Created by Guiyang Li on 2019/11/1.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class ViewController: RootViewController {

    // MARK: Properties

    let lockScreenVC = LockScreenViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func addSubviews() {
        let rootNav = UINavigationController(rootViewController: lockScreenVC)
        addChild(rootNav)
        view.addSubview(lockScreenVC.view)
    }

    override func makeConstants() {
        lockScreenVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }

    // MARK: private methods
}

