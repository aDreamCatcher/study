//
//  WebViewController.swift
//  SwiftUtilities
//
//  Created by Guiyang Li on 2019/3/13.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class WebViewController: UIViewController{

    private var webView: UIWebView?

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = UIWebView(frame: view.bounds)
        webView?.delegate = self
        webView?.scrollView.delegate = self

        if let webView = webView {
            view.addSubview(webView)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadRequest()
    }

    private func loadRequest() {
        let urlStr = "http://photo.china.com.cn/2019-03/13/content_74564732.htm" // "https://www.linkedin.com/wukong-web/salaryInsights"
        let url = URL(string: urlStr)
        if let url = url {
            webView?.loadRequest(URLRequest(url: url))
        }
    }
}

// Interfaces
extension WebViewController {

    public func webTitle() -> String? {
        return webView?.stringByEvaluatingJavaScript(from: "document.title")
    }
}

extension WebViewController: UIWebViewDelegate {

    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewDidStartLoad - ", webView.request?.url?.absoluteString)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        let webTitle = webView.stringByEvaluatingJavaScript(from: "document.title")

        self.title = webTitle
        print("webViewDidFinishLoad - title: ", webTitle)
    }
}

extension WebViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let webTitle = webView?.stringByEvaluatingJavaScript(from: "document.title")
        self.title = webTitle
    }
}
