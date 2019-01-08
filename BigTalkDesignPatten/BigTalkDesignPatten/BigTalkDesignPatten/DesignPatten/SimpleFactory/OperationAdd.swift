//
//  AddOperation.swift
//  BigTalkDesignPatten
//
//  Created by lgy on 2019/1/8.
//  Copyright © 2019 lgy. All rights reserved.
//

import Foundation

class OperationAdd: Operation {
    override func getResult() throws -> Double {
        let result = numberA + numberB

        return result
    }
}
