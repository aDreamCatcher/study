//
//  ShareViewController.swift
//  shares
//
//  Created by Guiyang Li on 2019/3/1.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        print("contentText: ", contentText)

        for item in extensionContext?.inputItems ?? [] {
            let item = item as! NSExtensionItem
            print("--- inputItems ---")
            print("attributedTitle: ", item.attributedTitle ?? "null")
            print("\nuserInfo: ", item.userInfo ?? "null")
            print("\nattachments: ", item.attachments ?? "null")
            print("\nattributedConentText: ", item.attributedContentText ?? "null")
        }

        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.

        let configurationItem = SLComposeSheetConfigurationItem()
        configurationItem?.title = "titleOne"
        configurationItem?.value = "valueOne"
        configurationItem?.valuePending = false
        configurationItem?.tapHandler = { [weak self] in
            self?.pushSelectViewController()
        }
        
        let configurationItem2 = SLComposeSheetConfigurationItem()
        configurationItem2?.title = "titleTwo"
        configurationItem2?.value = "valueTwo"
        configurationItem2?.valuePending = false
        configurationItem2?.tapHandler = { [weak self] in
            self?.pushSelectViewController()
        }

        if let configurationItem = configurationItem,
            let configurationItem2 = configurationItem2 {
            return [configurationItem, configurationItem2]
        }

        return []
    }
}

// MARK: - private methods
extension ShareViewController {
    func pushSelectViewController() {

        let selectViewController = SelectViewController { [weak self] (selectText) in
            self?.textView.text = self?.contentText.appending(" - \(selectText)")
            self?.popConfigurationViewController()
        }
        
        pushConfigurationViewController(selectViewController)
    }
}
