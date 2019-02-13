//
//  Solution.swift
//  PMainThreadWatcherDemo
//
//  Created by Xin on 2019/2/12.
//  Copyright © 2019 Xin. All rights reserved.
//

import Foundation

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        next = nil
    }
}

class Solution {
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {



        while (l1 != nil) {
            let val1 = l1?.val
            let val2 = l2?.val

            let sum = val1! + val2!
            let quotient = sum / 10
            let remainder = sum % 10

        }

        return nil
    }
}
