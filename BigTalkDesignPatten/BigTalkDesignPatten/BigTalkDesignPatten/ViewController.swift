//
//  ViewController.swift
//  BigTalkDesignPatten
//
//  Created by lgy on 2019/1/8.
//  Copyright © 2019 lgy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        simpleFactory()
    }



    // MARK: -design patten

    private func simpleFactory() {

        /// nested test function
        func testOperate(operate: String) {
            if let operation = OperationFactory.makeOperate(operate: operate) {
                operation.numberA = 100.0
                operation.numberB = 0.0

                do {
                    let result = try operation.getResult()
                    print("+ operationResult: ", result)
                } catch let error {
                    print("+ operationError: ", error)
                }
            } else {
                print("no this operation: \"" + operate + "\"")
            }
        }

        testOperate(operate: "+")
        testOperate(operate: "/")
        testOperate(operate: "^")
    }

}


