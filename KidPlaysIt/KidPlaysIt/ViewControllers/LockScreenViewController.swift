//
//  LockScreenViewController.swift
//  KidPlaysIt
//
//  Created by Guiyang Li on 2019/11/1.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class LockScreenViewController: RootViewController {

    // MARK: Properties

    private let backgroundImgView: UIImageView = {
        let imgView = UIImageView(image: NativeImage.lockScreen)
        return imgView
    }()

    override func addSubviews() {
        view.addSubview(backgroundImgView)
    }

    override func makeConstants() {
        backgroundImgView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
}
