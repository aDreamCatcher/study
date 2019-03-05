//
//  RandomUserAgent.swift
//  SwiftUtilities
//
//  Created by Guiyang Li on 2019/3/5.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class RandomUserAgentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    func setupUI() {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        button.frame = CGRect(x: 20, y: 100, width: 200, height: 60)

        view.addSubview(button)
    }

    @objc func sendRequest() {
        let url = URL(string: "http://www.baidu.com")
        if let url = url {
            var request = URLRequest(url: url)
            request.setValue(UserAgent.randomValue,
                             forHTTPHeaderField: "User-Agent")
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                print("data: ", data)
                print("\n-----\n response: ", response)
                print("\n-----\n error: ", error)

                let result = (error == nil) ? "Success" : "Failed"

                DispatchQueue.main.async {
                    let alertC = UIAlertController(title: "SentResult",
                                                   message: result,
                                                   preferredStyle: .alert)

                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { [weak alertC] (action) in
                        alertC?.dismiss(animated: true, completion: nil)
                    })
                    alertC.addAction(okAction)

                    self?.show(alertC, sender: nil)
                }
            }

            dataTask.resume()
        }
    }
}
