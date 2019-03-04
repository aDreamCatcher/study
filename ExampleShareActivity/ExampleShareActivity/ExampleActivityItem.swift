//
//  ExampleActivityItem.swift
//  ExampleShareActivity
//
//  Created by Guiyang Li on 2019/2/27.
//  Copyright © 2019 Xin. All rights reserved.
//

import Foundation
import Social
import MobileCoreServices

public class ExampleActivityItem: NSObject {
    public var text: String
    public var image: UIImage?
    public var subject: String?

    public convenience override init() {
        self.init("Default")
    }

    public init(_ text: String, image: UIImage? = nil, subject: String? = nil) {
        self.text = text
        self.image = image
        self.subject = subject
    }
}

extension ExampleActivityItem: UIActivityItemSource {

    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        if subject != nil {
            return self
        }

        if let image = image {
            return image
        }

        return text
    }

    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if subject != nil {
            return self
        }

        if let image = image {
            return image
        }

        return text
    }


    public func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return subject ?? "Default"
    }

    public func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String {
        if subject != nil {
            return "com.xin.ExampleShareActivity-subject"
        }

        if image != nil {
            return kUTTypeImage as String
        }

        // kUTTypePlainText 对应 NSExtensionActivationSupportsText(shareExtension)
        return kUTTypePlainText as String
    }
}
