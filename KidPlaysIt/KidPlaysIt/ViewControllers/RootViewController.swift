//
//  RootViewController.swift
//  KidPlaysIt
//
//  Created by Guiyang Li on 2019/11/1.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit
import SnapKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        addSubviews()
        makeConstants()
    }

    public func addSubviews() {}
    public func makeConstants() {}
}

// MARK: Configure

extension RootViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
