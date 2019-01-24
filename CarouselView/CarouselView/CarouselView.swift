//
//  CarouselView.swift
//  CarouselView
//
//  Created by lgy on 2019/1/23.
//  Copyright © 2019 lgy. All rights reserved.
//

import UIKit

class CarouselView: UIView {

    // MARK: - properties

    fileprivate var dataSource = [String]()
    fileprivate var collectionView: UICollectionView!

    fileprivate let itemSize: CGSize

    public init(_ frame: CGRect,
                itemSize: CGSize,
                itemSpace: CGFloat,
                dataSource: [String]?) {
        self.itemSize = itemSize

        let horizontalLayout = HorizontalFlowLayout()
        horizontalLayout.itemSize = itemSize
        horizontalLayout.minimumLineSpacing = itemSpace

        let rect = CGRect(origin: CGPoint.zero,
                             size: frame.size)
        collectionView = UICollectionView(frame: rect,
                                          collectionViewLayout: horizontalLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .normal
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CarouselCollectionViewCell.self,
                                forCellWithReuseIdentifier: CarouselCollectionViewCell.reuseIdentifier)

        super.init(frame: frame)

        collectionView.dataSource = self
        collectionView.delegate = self

        if let dataSource = dataSource {
            self.dataSource = dataSource
        }

        addSubview(collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as! CarouselCollectionViewCell

        cell.backgroundColor = UIColor.yellow
        cell.setData(dataSource[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,
                            left: (collectionView.frame.size.width - itemSize.width) * 0.5,
                            bottom: 0,
                            right: (collectionView.frame.size.width - itemSize.width) * 0.5)
    }
}

class HorizontalFlowLayout: UICollectionViewFlowLayout {

    public override init() {
        super.init()

        self.scrollDirection = .horizontal
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude

        let centerX = proposedContentOffset.x + (collectionView?.bounds.width ?? 0) * 0.5
        let targetRect = CGRect(x: proposedContentOffset.x,
                                y: 0,
                                width: collectionView?.bounds.width ?? 0,
                                height: collectionView?.bounds.height ?? 0)

        let attributes = super.layoutAttributesForElements(in: targetRect)
        for layoutAttribute in attributes ?? [] {
            let itemCenterX = layoutAttribute.center.x

            if abs(itemCenterX - centerX) < abs(offsetAdjustment) {
                offsetAdjustment = itemCenterX - centerX
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment,
                       y: proposedContentOffset.y)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
