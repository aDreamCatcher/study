//
//  OperationMul.swift
//  BigTalkDesignPatten
//
//  Created by lgy on 2019/1/8.
//  Copyright © 2019 lgy. All rights reserved.
//

import Foundation

class OperationMul: Operation {
    override func getResult() throws -> Double {
        let result = numberA * numberB

        return result
    }
}
