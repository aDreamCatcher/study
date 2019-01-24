//
//  CarouselView.swift
//  CarouselView
//
//  Created by lgy on 2019/1/23.
//  Copyright © 2019 lgy. All rights reserved.
//

import UIKit

public enum CarouselScrollDirection {
    case last
    case next
}

class CarouselView: UIView {
    
    // MARK: - constants
    private enum Constant{
        static let designItemWidth: CGFloat = 295.0 // itemWidth = designItemWidth * scale
        static let designItemHeight: CGFloat = 110.0 // scale = frame.size.height / designItemHeight
        static let designItemSpace: CGFloat = 16.0 // no scale
        
        static let displayColor = UIColor.white
        static let blurColor = UIColor.init(white: 1.0, alpha: 0.5)
    }
    
    // MARK: properties
    
    fileprivate var dataSource = [String]()
    fileprivate var collectionView: UICollectionView!
    fileprivate var scrollEndBlock: ((_ index: Int) -> Void)?
    fileprivate var isScrolling: Bool = false

    fileprivate var scale: CGFloat // calculate width with height
    private var currentIndexPath: IndexPath
    

    // MARK: lifecycle
    
    public init(_ frame: CGRect,
                dataSource: [String]?,
                scrollEndCallBack: ((_ index: Int) -> Void)?) {
        scrollEndBlock = scrollEndCallBack
        
        scale = frame.size.height / Constant.designItemHeight
        currentIndexPath = IndexPath(row: 0, section: 0)

        let horizontalLayout = HorizontalFlowLayout()
        horizontalLayout.itemSize = CGSize(width: Constant.designItemWidth * scale,
                                           height: frame.size.height)
        horizontalLayout.minimumLineSpacing = Constant.designItemSpace

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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Duplicate code needs to be optimized
        scale = frame.size.height / Constant.designItemHeight
        currentIndexPath = IndexPath(row: 0, section: 0)
        
        let horizontalLayout = HorizontalFlowLayout()
        horizontalLayout.itemSize = CGSize(width: Constant.designItemWidth * scale,
                                           height: frame.size.height)
        horizontalLayout.minimumLineSpacing = Constant.designItemSpace
        
        let rect = CGRect(origin: CGPoint.zero,
                          size: frame.size)
        collectionView.frame = rect
        collectionView.collectionViewLayout = horizontalLayout
    }
    
    
    // MARK: interface
    
    public func scroll(_ to: CarouselScrollDirection) {
        guard let toIndexPath = indexPathOf(to)else {
            return
        }
        
        resetCellStyle(isScrolling: true)
        collectionView.scrollToItem(at: toIndexPath,
                                    at: .centeredHorizontally,
                                    animated: true)
    }
    
    // MARK: private methods
    
    /// calculate destination indexPath
    fileprivate func indexPathOf(_ direction: CarouselScrollDirection) -> IndexPath? {
        guard dataSource.count > 0 else {
            return nil
        }
        
        if direction == .last,
            currentIndexPath.row > 0{
            currentIndexPath = IndexPath(row: currentIndexPath.row - 1,
                                         section: currentIndexPath.section)
            return currentIndexPath
        }
        
        if direction == .next,
            currentIndexPath.row < (dataSource.count - 1) {
            currentIndexPath = IndexPath(row: currentIndexPath.row + 1,
                                         section: currentIndexPath.section)
            return currentIndexPath
        }
        
        return currentIndexPath
    }
    
    // should be invoked when scroll end
    private func resetCurrentIndexPath(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.frame.size.width
        let centerX = scrollView.contentOffset.x + scrollViewWidth * 0.5
        
        for index in 0..<dataSource.count {
            let isThisIndex = (centerX > CGFloat(index) * scrollViewWidth) && (centerX < CGFloat(index+1) * scrollViewWidth)
            if isThisIndex {
                currentIndexPath = IndexPath(row: index,
                                             section: currentIndexPath.section)
                break
            }
        }
    }
    
    /// reset cell backgroundStyle
    private func resetCellStyle(isScrolling: Bool) {
        self.isScrolling = isScrolling
        DispatchQueue.main.async {
            self.collectionView .reloadData()
        }
    }
    
    /// get cell backgroundColor
    fileprivate func cellBackgoundColor(_ indexPath: IndexPath) -> UIColor {
        if isScrolling {
            return Constant.displayColor
        }
        
        return (indexPath.row == currentIndexPath.row) ? Constant.displayColor : Constant.blurColor;
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as! CarouselCollectionViewCell
        
        cell.setData(dataSource[indexPath.row])
        cell.backgroundColor = cellBackgoundColor(indexPath)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let collectionViewWidth = collectionView.frame.size.width
        let cellWidth = Constant.designItemWidth * scale
        return UIEdgeInsets(top: 0,
                            left: (collectionViewWidth - cellWidth) * 0.5,
                            bottom: 0,
                            right: (collectionViewWidth - cellWidth) * 0.5)
    }
}

// MARK: -  UIScrollViewDelegate

extension CarouselView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resetCellStyle(isScrolling: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        
        resetCurrentIndexPath(scrollView)
        scrollEndCallBack()
        resetCellStyle(isScrolling: false)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation ")
        //
//        resetCurrentIndexPath(scrollView)
        scrollEndCallBack()
        resetCellStyle(isScrolling: false)
    }
    
    fileprivate func scrollEndCallBack() {
        guard let scrollEndBlock = scrollEndBlock else {
            return
        }
        scrollEndBlock(currentIndexPath.row)
    }
}


// MARK: - HorizontalFlowLayout

class HorizontalFlowLayout: UICollectionViewFlowLayout {

    public override init() {
        super.init()

        self.scrollDirection = .horizontal
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // stop at center point
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let centerX = proposedContentOffset.x + (collectionView?.bounds.width ?? 0) * 0.5
        
        // get nearest attribute
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
}

// MARK: - CarouselCollectionViewCell

class CarouselCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CarouselCollectionViewCellReuseIdentifier"
    
    private let label: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.init(white: 0.0, alpha: 0.9)
        label.font = UIFont(name: "PingFangSC-Semibold", size: 20.0)
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = self.bounds
        contentView.addSubview(label)
        
        // round corner
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = self.bounds
    }
    
    public func setData(_ text: String) {
        label.text = text
    }
}
