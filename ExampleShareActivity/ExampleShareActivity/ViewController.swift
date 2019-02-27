//
//  ViewController.swift
//  ExampleShareActivity
//
//  Created by Guiyang Li on 2019/2/27.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let button = UIButton(type: .custom)
        button.setTitle("PresentShare", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.frame = CGRect(x: 20, y: 100, width: 200, height: 100)

        view.addSubview(button)

//        // UIImageView
//
//        let imgV = UIImageView(image: UIImage(named: "face"))
//        imgV.frame = CGRect(x: 20, y: 220, width: 200, height: 200)
//        view.addSubview(imgV)
    }

    @objc public func buttonAction() {

        // UIActivityItems
        let textItem = ExampleActivityItem("Pig")
        let imageItem = ExampleActivityItem("Smiling Face", image: UIImage(named: "face"))
        let customItem = ExampleActivityItem("multi-data", image: UIImage(named: "face"), subject: "This is a smile.")

        let activityItems = [textItem, imageItem ,customItem]

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

