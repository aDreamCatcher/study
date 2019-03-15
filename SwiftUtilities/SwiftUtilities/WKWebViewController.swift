//
//  WKWebViewController.swift
//  SwiftUtilities
//
//  Created by Guiyang Li on 2019/3/13.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {

    private var scrollView: UIScrollView?
    private var wkWebView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()

//        // scrollView
//        scrollView = UIScrollView(frame: CGRect(x: 0,
//                                                y: 0,
//                                                width: view.frame.size.width,
//                                                height: view.frame.size.height))
//        scrollView?.backgroundColor = UIColor.gray
//
//        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        subview.backgroundColor = UIColor.red
//        scrollView?.addSubview(subview)
//
//        if let scrollView = scrollView {
//            (navigationController?.view ?? view).addSubview(scrollView)
//        }

        //
        wkWebView = WKWebView(frame: view.bounds)

        if let wkWebView = wkWebView {
            view.addSubview(wkWebView)

            addTitleKVO()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadRequest()
    }


    private func addTitleKVO() {
        wkWebView?.addObserver(self, forKeyPath: "title", options: [.new], context: nil)
    }

    private func loadRequest() {
        let url = URL(string: "https://www.linkedin.com/wukong-web/salaryInsights")

        if let url = url {
            let request = URLRequest(url: url)
            wkWebView?.load(request)
        }
    }
}

extension WKWebViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath,
            keyPath == "title" {
            title = wkWebView?.title
        }
    }
}

