//
//  ExampleActivity.swift
//  ExampleShareActivity
//
//  Created by Guiyang Li on 2019/2/27.
//  Copyright © 2019 Xin. All rights reserved.
//

import Foundation
import Social

class ExampleActivity: UIActivity {
    public var title: String
    public var image: UIImage?
    public var action: ([Any]) -> Void
    public var items = [Any]()

    init(_ title: String, image: UIImage?, performAction: @escaping ([Any]) -> Void) {
        self.title = title
        self.image = image
        self.action = performAction

        super.init()
    }
}

// MARK: Override
extension ExampleActivity {

    open override class var activityCategory: UIActivity.Category {
        return Category.share
    }

    override var activityType: UIActivity.ActivityType? {
        return ActivityType(rawValue: "com.tencent.xin.sharetimeline");
    }

    override var activityTitle: String? {
        return title
    }

    override var activityImage: UIImage? {
        return image
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }

    override func prepare(withActivityItems activityItems: [Any]) {
        self.items = activityItems
    }

    override var activityViewController: UIViewController? {
        return nil
    }

    override func perform() {
        action(items)
        activityDidFinish(true)
    }

}
