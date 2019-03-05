//
//  UserAgent.swift
//  SwiftUtilities
//
//  Created by Guiyang Li on 2019/3/5.
//  Copyright © 2019 Xin. All rights reserved.
//

import Foundation

public struct UserAgent {

    private static let chromeOnMBP = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36"

    private static let safariOnMBP = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.2 Safari/605.1.15"

    private static let fireFoxOnMBP = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:65.0) Gecko/20100101 Firefox/65.0"

    private static let IE10 = "Mozilla/5.0 (compatible; WOW64; MSIE 10.0; Windows NT 6.2)"

    private static let IE11 = "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; AS; rv:11.0) like Gecko"

    private static var userAgents: [String] = [UserAgent.chromeOnMBP, UserAgent.safariOnMBP, UserAgent.fireFoxOnMBP, UserAgent.IE10, UserAgent.IE11]

    public static var randomValue: String {
        let index = arc4random_uniform(UInt32(userAgents.count))
        return userAgents[Int(index)]
    }
}
