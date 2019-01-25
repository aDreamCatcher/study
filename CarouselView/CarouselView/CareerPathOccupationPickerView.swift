//
//  CareerPathOccupationPickerView.swift
//  VoyagerFeedShell
//
//  Created by lgy on 2019/1/23.
//  Copyright © 2019 lgy. All rights reserved.
//

import UIKit

public enum OccupationScrollDirection {
    case last
    case next
}

class CareerPathOccupationPickerView: UIView {
    
    // MARK: constants
    private enum Constant{
        static let designItemWidth: CGFloat = 295.0 // itemWidth = designItemWidth * scale
        static let designItemHeight: CGFloat = 110.0 // scale = frame.size.height / designItemHeight
        static let designItemSpace: CGFloat = 16.0 // no scale
        
        static let displayColor = UIColor.white
        static let blurColor = UIColor.init(white: 1.0, alpha: 0.5)
    }
    
    // MARK: properties
    
    private var dataSource = [String]()
    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: HorizontalFlowLayout())
    private var scrollEndBlock: ((_ index: Int) -> Void)?
    private var isScrolling: Bool = false // get cellBackgoundColor with isScrolling

    private var scale: CGFloat = 1 // calculate width with height
    private var currentIndexPath = IndexPath(row: 0, section: 0)
    private var lastCallbackIndexPath: IndexPath?
    
    
    // MARK: lifecycle
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        scale = frame.size.height / Constant.designItemHeight

        // create horizontal layout
        let horizontalLayout = HorizontalFlowLayout()
        horizontalLayout.itemSize = CGSize(width: Constant.designItemWidth * scale,
                                           height: frame.size.height)
        horizontalLayout.minimumLineSpacing = Constant.designItemSpace

        // config collectionView
        collectionView.collectionViewLayout = horizontalLayout
        collectionView.frame = CGRect(origin: .zero,
                                      size: frame.size)
    }

    private func setupUI() {
        backgroundColor = UIColor.clear
        
        scale = frame.size.height / Constant.designItemHeight

        // create horizontal layout
        let horizontalLayout = HorizontalFlowLayout()
        horizontalLayout.itemSize = CGSize(width: Constant.designItemWidth * scale,
                                           height: frame.size.height)
        horizontalLayout.minimumLineSpacing = Constant.designItemSpace
        
        // config collectionView
        collectionView.collectionViewLayout = horizontalLayout
        collectionView.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        collectionView.decelerationRate = UIScrollViewDecelerationRateNormal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(OccupationCollectionViewCell.self,
                                forCellWithReuseIdentifier: OccupationCollectionViewCell.reuseIdentifier)

        collectionView.dataSource = self
        collectionView.delegate = self

        addSubview(collectionView)
    }
    
    // MARK: interface
    // scroll to last/next item
    public func scroll(_ to: OccupationScrollDirection) {
        guard let toIndexPath = indexPathOf(to)else {
            return
        }
        
        if toIndexPath.row != currentIndexPath.row {
            resetCellStyle(isScrolling: true)
            collectionView.scrollToItem(at: toIndexPath,
                                        at: .centeredHorizontally,
                                        animated: true)
        }
    }

    // set datasource and default display index
    public func setDataSource(_ theDataSource: [String], selectedIndex: Int) {
        if theDataSource.count > 0,
            selectedIndex < theDataSource.count,
            selectedIndex >= 0 {
            // theDataSource and selectIndex valid - do this
            dataSource = theDataSource
            currentIndexPath = IndexPath(row: selectedIndex,
                                         section: 0)
            
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: self.currentIndexPath,
                                                 at: .centeredHorizontally,
                                                 animated: false)
            }
        }
    }

    public func setScrollEndCallback(_ callback: ((_ index: Int) -> Void)?) {
        scrollEndBlock = callback
    }
    
    // MARK: private methods
    
    // calculate destination indexPath
    private func indexPathOf(_ direction: OccupationScrollDirection) -> IndexPath? {
        guard dataSource.count > 0 else {
            return nil
        }
        
        if direction == .last,
            currentIndexPath.row > 0{
            return IndexPath(row: currentIndexPath.row - 1,
                             section: currentIndexPath.section)
        }
        
        if direction == .next,
            currentIndexPath.row < (dataSource.count - 1) {
            return IndexPath(row: currentIndexPath.row + 1,
                             section: currentIndexPath.section)
        }
        
        return currentIndexPath
    }
    
    // should be invoked when scroll end
    private func resetCurrentIndexPath(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.frame.size.width
        let centerX = scrollView.contentOffset.x + scrollViewWidth * 0.5
        
        let cellWidth = Constant.designItemWidth * scale
        let leftEdge = (scrollViewWidth - cellWidth) * 0.5
        let cellOccupiedWidth = cellWidth + Constant.designItemSpace
        
        for index in 0..<dataSource.count {
            let cellOriginX = leftEdge + CGFloat(index) * cellOccupiedWidth
            let cellEndX = cellOriginX + cellWidth
            
            let isCellCenter = (centerX > cellOriginX) && (centerX < cellEndX)
            if isCellCenter {
                currentIndexPath = IndexPath(row: index,
                                             section: currentIndexPath.section)
                break
            }
        }
    }
    
    // reset cell backgroundStyle
    private func resetCellStyle(isScrolling: Bool) {
        self.isScrolling = isScrolling
        DispatchQueue.main.async {
            self.collectionView .reloadData()
        }
    }
    
    /// get cell backgroundColor
    private func cellBackgoundColor(_ indexPath: IndexPath) -> UIColor {
        if isScrolling {
            return Constant.displayColor
        }
        
        return (indexPath.row == currentIndexPath.row) ? Constant.displayColor : Constant.blurColor;
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension CareerPathOccupationPickerView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OccupationCollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as! OccupationCollectionViewCell
        
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

extension CareerPathOccupationPickerView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard isScrolling else {
            resetCellStyle(isScrolling: true)
            return
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(scrollView)
    }
    
    // should be invoked when scroll view did end scroll
    private func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        
        resetCurrentIndexPath(scrollView)
        resetCellStyle(isScrolling: false)
        
        scrollEndCallBack()
    }
    
    private func scrollEndCallBack() {
        guard let scrollEndBlock = scrollEndBlock else {
            return
        }
        // if lastIndexPath != currentIndexPath, do callBack
        if lastCallbackIndexPath == nil ||
            lastCallbackIndexPath?.row != currentIndexPath.row {
            lastCallbackIndexPath = currentIndexPath
            scrollEndBlock(currentIndexPath.row)
        }
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

// MARK: - OccupationCollectionViewCell

class OccupationCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "OccupationCollectionViewCellReuseIdentifier"
    
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
