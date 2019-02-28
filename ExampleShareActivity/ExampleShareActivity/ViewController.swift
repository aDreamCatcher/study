//
//  ViewController.swift
//  ExampleShareActivity
//
//  Created by Guiyang Li on 2019/2/27.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var documentInteractionController: UIDocumentInteractionController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let button = UIButton(type: .custom)
        button.setTitle("activityShare", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.frame = CGRect(x: 20, y: 100, width: 200, height: 100)

        let button2 = UIButton(type: .custom)
        button2.setTitle("documentShare", for: .normal)
        button2.setTitleColor(UIColor.red, for: .normal)
        button2.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
        button2.frame = CGRect(x: 20, y: 220, width: 200, height: 100)

        view.addSubview(button)
        view.addSubview(button2)
    }

}

// MARK: UIActivityViewController
extension ViewController {

    @objc public func buttonAction() {
        // UIActivityItems
        let textItem = ExampleActivityItem("Pig")
        let imageItem = ExampleActivityItem("Smiling Face", image: UIImage(named: "face"))
        let customItem = ExampleActivityItem("multi-data", image: UIImage(named: "face"), subject: "This is a smile.")

        let activityItems: [Any] = [textItem, ""]
//        let activityItems: [Any] = [textItem, imageItem, customItem]

        // UIActivitys
        let activity = ExampleActivity("SmilingFace", image: UIImage(named: "face_60")) { (items) in
            for item in items {
                print(item.self)
                if item is ExampleActivityItem {
                    print("subject: ", (item as! ExampleActivityItem).subject ?? "nil")
                }
            }
        }

        let activities = [activity]

        // present activityViewController
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: activities)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.openInIBooks]
        activityViewController.modalPresentationStyle = .custom

        present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: UIDocumentInteractionController

extension ViewController {

    @objc public func buttonAction2() {
        //        let facePath = Bundle.main.path(forResource: "face", ofType: "png")
        //        let faceURL = URL(fileURLWithPath: facePath ?? "")

        let filePath = textFilePath("344944410@qq.com")
        let fileURL = URL(fileURLWithPath: filePath)

        documentInteractionController = UIDocumentInteractionController(url: fileURL)
        documentInteractionController?.delegate = self

        //        documentInteractionController?.presentPreview(animated: true)
        documentInteractionController?.presentOptionsMenu(from: .zero,
                                                          in: view,
                                                          animated: true)
    }

    private func textFilePath(_ content: String) -> String {
        let dirPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = dirPath.appending("/local.txt")

        let fileExist = FileManager.default.fileExists(atPath: filePath)
        if !fileExist {
        }

        do {
            try content.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("")
        }


        return filePath
    }
}

extension ViewController: UIDocumentInteractionControllerDelegate {

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return view
    }

    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return view.bounds
    }

}

