//
//  OperationDiv.swift
//  BigTalkDesignPatten
//
//  Created by lgy on 2019/1/8.
//  Copyright © 2019 lgy. All rights reserved.
//

import Foundation

class OperationDiv: Operation {

    override func getResult() throws -> Double {
        if numberB == 0 {
            throw NSError(domain: "the divisor can not be zero", code: 0, userInfo: nil)
        }

        let result = numberA / numberB

        return result
    }
}
