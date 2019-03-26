//
//  SlideBlockView.swift
//  SwiftUtilities
//
//  Created by Guiyang Li on 2019/3/25.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class SlideBlockView: UIView {

    public enum Direction {
        case last
        case next
    }

    // MARK: - constants

    private enum Constant{
        // itemWidth = designItemWidth * scale
        static let designItemWidth: CGFloat = 295.0
        // scale = frame.size.height / designItemHeight
        static let designItemHeight: CGFloat = 110.0
        // no scale
        static let designItemSpace: CGFloat = 16.0

        static let backgroundColor = UIColor.clear
        static let displayColor = UIColor.white
        static let blurColor = UIColor(white: 1.0, alpha: 0.5)
    }

    // MARK: - properties

    private var dataSource = [String]()
    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: HorizontalFlowLayout())
    private var scrollEndBlock: ((_ index: Int) -> Void)?
    // get cellBackgoundColor with isScrolling
    private var isScrolling: Bool = false

    // calculate width with height
    private var scale: CGFloat = 1
    private var currentIndexPath = IndexPath(row: 0, section: 0)
    private var lastCallbackIndexPath: IndexPath?


    // MARK: - lifecycle

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        resetHorizontalLayout()
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let cell = collectionView(collectionView, cellForItemAt: IndexPath(row: 1, section: 0)) as! OccupationCollectionViewCell

        let hitPoint = convert(point, to: collectionView)
        let labRect = convert(cell.labFrame , to: collectionView)

        if labRect.contains(hitPoint) {
            return true
        }
        
        return false
    }

    private func setupUI() {
        backgroundColor = Constant.backgroundColor

        resetHorizontalLayout()

        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Constant.backgroundColor
        collectionView.register(OccupationCollectionViewCell.self,
                                forCellWithReuseIdentifier: OccupationCollectionViewCell.reuseIdentifier)

        collectionView.dataSource = self
        collectionView.delegate = self

        addSubview(collectionView)
    }

    private func resetHorizontalLayout() {
        scale = frame.size.height / Constant.designItemHeight

        // create horizontal layout
        let horizontalLayout = HorizontalFlowLayout()
        horizontalLayout.itemSize = CGSize(width: Constant.designItemWidth * scale,
                                           height: frame.size.height)
        horizontalLayout.minimumLineSpacing = Constant.designItemSpace
        horizontalLayout.minimumInteritemSpacing = Constant.designItemSpace

        // config collectionView
        collectionView.collectionViewLayout = horizontalLayout
        collectionView.frame = CGRect(origin: .zero,
                                      size: frame.size)
    }

    // MARK: - interface
    // scroll to last/next item
    public func scroll(_ to: Direction) {
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
            self.collectionView.reloadData()

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

    // MARK: - private methods

    // calculate destination indexPath
    private func indexPathOf(_ direction: Direction) -> IndexPath? {
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

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = layout.itemSize.width
        let cellOccupiedWidth = cellWidth + Constant.designItemSpace
        let leftEdge = (scrollViewWidth - cellWidth) * 0.5
        // get current item's index
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
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension SlideBlockView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OccupationCollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as! OccupationCollectionViewCell

        cell.setData(dataSource[indexPath.row])
        cell.tag = indexPath.row

//        cell.isUserInteractionEnabled = (indexPath.row == 0)

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

extension SlideBlockView: UIScrollViewDelegate {
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

    fileprivate enum Constant {
        static let backgroundColor = UIColor.white
        static let cornerRadius: CGFloat = 8.0
    }

    private let label: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = Constant.backgroundColor
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.frame = labFrame
        contentView.addSubview(label)

        contentView.backgroundColor = UIColor.red

        // round corner
        layer.cornerRadius = Constant.cornerRadius
        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        label.frame = labFrame
    }

    public func setData(_ text: String) {
        label.text = text
    }

    // MARK: private methods
    public var labFrame: CGRect {
        var labFrame = bounds
        if (bounds.size.width > bounds.size.height) {
            let labW = bounds.height - 20
            let oriX = (bounds.size.width - labW) * 0.5

            labFrame = CGRect(x: oriX,
                          y: 10,
                          width: labW,
                          height: labW)
        } else {
            let labW = bounds.width - 20
            let oriY = (bounds.height - labW) * 0.5

            labFrame = CGRect(x: 10,
                              y: oriY,
                              width: labW,
                              height: labW)
        }

        return labFrame
    }
}
