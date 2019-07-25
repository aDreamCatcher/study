//
//  ViewController.swift
//  SwiftUtilities
//
//  Created by Guiyang Li on 2019/3/4.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var items: [String] = {
        return ["RandomUserAgent", "webView.title", "wkWebView.Title", "presentNav", "SliderElement"]
    }()

    public var collectionView: UICollectionView?

    public var refreshControl: UIRefreshControl?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        setupUI()
        sequenceLazy() // Do you really understand lazy.
    }

    // MARK: UI
    private func setupUI() {
        let width = view.frame.size.width
        let frame = view.bounds

        // collection view
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0,
                                               left: 20,
                                               bottom: 0,
                                               right: 20)
        flowLayout.itemSize = CGSize(width: width,
                                     height: 44.0)
        flowLayout.minimumLineSpacing = 1.0

        collectionView = UICollectionView(frame: frame,
                                          collectionViewLayout: flowLayout)
        collectionView?.register(BaseCollectionViewCell.self,
                                 forCellWithReuseIdentifier: BaseCollectionViewCell.reuseID)
        collectionView?.backgroundColor = UIColor.yellow
        collectionView?.dataSource = self
        collectionView?.delegate = self

        // refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.blue
        refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新...")
        refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)

        // addSubviews
        if let collectionView = collectionView,
            let refreshControl = refreshControl {
            view.addSubview(collectionView)
            collectionView.addSubview(refreshControl)
        }
    }
}

// MARK: - UIRefreshControl
extension ViewController {
    @objc func refreshControlValueChanged() {
        refreshControl?.attributedTitle = NSAttributedString(string: "开始加载...")

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "加载完毕！")
            self.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - UICollectionView delegate and datasource
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCollectionViewCell.reuseID,
                                                      for: indexPath) as! BaseCollectionViewCell
        cell.setText(items[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelect: ", items[indexPath.row])

        var viewController: UIViewController?
        switch indexPath.row {
        case 0:
            viewController = RandomUserAgentViewController()
        case 1:
            viewController = WebViewController()
        case 2:
            viewController = WKWebViewController()
        case 3:
            presentNav()
        case 4:
            viewController = SlideBlockViewController()
        default:
            print("")
        }

        if let viewController = viewController {
            navigationController?.pushViewController(viewController,
                                                     animated: true)
        }
    }
}

extension ViewController {
    private func presentNav() {
        let vc = ViewController()
//        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "leftBarItem", style: .plain, target: self, action: #selector(dismissAction))

        let nav = UINavigationController(rootViewController: vc)
        present(nav,
                animated: true,
                completion: nil)
    }

    @objc private func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - some knowledge

extension ViewController {

    /// Do you really understand lazy
    private func sequenceLazy() {
        let data = 1...3
        let results = data.lazy.map { (element) -> Int in
            print("正在处理 \(element)")
            return element * 2
        }

        print("准备访问结果...")
        for element in results {
            print("处理后结果为 \(element)")
        }

//        print("处理后结果为 \(results.last)")


        print("Done")
    }
}
