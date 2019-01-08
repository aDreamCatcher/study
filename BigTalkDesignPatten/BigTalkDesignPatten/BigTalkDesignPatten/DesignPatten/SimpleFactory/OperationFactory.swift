//
//  OperationFactory.swift
//  BigTalkDesignPatten
//
//  Created by lgy on 2019/1/8.
//  Copyright © 2019 lgy. All rights reserved.
//

import Foundation

class OperationFactory {

    // MARK: -simple factory method
    static func makeOperate(operate: String) -> Operation? {

        var operation: Operation?

        switch operate {
        case "+":
            operation = OperationAdd()
        case "-":
            operation = OperationSub()
        case "*":
            operation = OperationMul()
        case "/":
            operation = OperationDiv()
        default:
            operation = nil
        }

        return operation
    }
}
