//
//  ShareSelectViewController.swift
//  shares
//
//  Created by Guiyang Li on 2019/3/1.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

public class SelectViewController: UIViewController {

    let items = ["select one", "select two"]

    var collectionView: UICollectionView? = nil

    var selectBlock: ((String) -> Void)? = nil

    init(_ select: @escaping (String) -> Void) {
        super.init(nibName: nil, bundle: nil)
        selectBlock = select
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    deinit {
        print("deinit: ",self)
    }

    // MARK: UI

    func setupUI() {
        // prepare
        let navBarWidth = navigationController?.navigationBar.frame.size.width
        let navBarBottom = (navigationController?.navigationBar.frame.origin.y ?? 0.0) + (navigationController?.navigationBar.frame.size.height ?? 0.0)

        let width = view.frame.size.width
        let height = view.frame.size.height

        let frame = CGRect(x: 0,
                           y: navBarBottom,
                           width: navBarWidth ?? width,
                           height: height)

        // flowLayout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.itemSize = CGSize(width: navBarWidth ?? width,
                                     height: 50)

        // collectionView
        collectionView = UICollectionView(frame: frame,
                                          collectionViewLayout: flowLayout)
        collectionView?.register(SelectCell.self, forCellWithReuseIdentifier: SelectCell.reuseID)
        collectionView?.backgroundColor = UIColor.blue
        collectionView?.dataSource = self
        collectionView?.delegate = self

        if let collectionView = collectionView {
            view.addSubview(collectionView)
        }

        view.backgroundColor = UIColor.purple
    }
}

// MARK: - UICollectionView datasource & delegate

extension SelectViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCell.reuseID, for: indexPath) as! SelectCell
        cell.setText(items[indexPath.row])
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block = selectBlock {
            block(items[indexPath.row])
            navigationController?.popViewController(animated: true)
        }
    }
}


