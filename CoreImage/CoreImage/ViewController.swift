//
//  ViewController.swift
//  CoreImage
//
//  Created by lgy on 2019/2/19.
//  Copyright © 2019 lgy. All rights reserved.
//

import UIKit
import GLKit

class ViewController: UIViewController {

    public var glkView: GLKView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let eaglContext = EAGLContext.init(api: .openGLES2)
        let ciContext = CIContext

    }


}

