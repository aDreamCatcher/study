//
//  Calculator.swift
//  BigTalkDesignPatten
//
//  Created by lgy on 2019/1/8.
//  Copyright © 2019 lgy. All rights reserved.
//

import Foundation

/**
 base class of operations
 */
class Operation {

    // MARK: -properties
    var numberA: Double = 0.0
    var numberB: Double = 0.0

    // MARK: -operate method
    public func getResult() throws -> Double {
        return 0.0
    }
}
