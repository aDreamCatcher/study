//
//  CareerPathOccupationPickerView.swift
//  CarouselView
//
//  Created by Guiyang Li on 2019/1/25.
//  Copyright © 2019 lgy. All rights reserved.
//

import UIKit

public enum OccupationScrollDirection {
    case last
    case next
}

class CareerPathOccupationPickerView: UIView {

    // MARK: - constants

    fileprivate enum Constant{
        // itemWidth = designItemWidth * scale
        static let designItemWidth: CGFloat = 295.0
        // scale = frame.size.height / designItemHeight
        static let designItemHeight: CGFloat = 110.0
        // no scale
        static let designItemSpace: CGFloat = 16.0
        // scroll view's velocity >= velocity: scroll to currentIndexPath's nearby item/cell
        // scroll view's velocity <  velocigy: scroll to proposedContentOffset's nearby item/cell
        static let velocity: CGFloat = 0.35

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
        horizontalLayout.minimumInteritemSpacing = Constant.designItemSpace

        // config collectionView
        collectionView.collectionViewLayout = horizontalLayout
        collectionView.frame = CGRect(origin: .zero,
                                      size: frame.size)
    }

    private func setupUI() {
        backgroundColor = Constant.backgroundColor

        scale = frame.size.height / Constant.designItemHeight

        // create horizontal layout
        let horizontalLayout = HorizontalFlowLayout()
        horizontalLayout.itemSize = CGSize(width: Constant.designItemWidth * scale,
                                           height: frame.size.height)
        horizontalLayout.minimumLineSpacing = Constant.designItemSpace
        horizontalLayout.minimumInteritemSpacing = Constant.designItemSpace

        // config collectionView
        collectionView.collectionViewLayout = horizontalLayout
        collectionView.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Constant.backgroundColor
        collectionView.register(OccupationCollectionViewCell.self,
                                forCellWithReuseIdentifier: OccupationCollectionViewCell.reuseIdentifier)

        collectionView.dataSource = self
        collectionView.delegate = self

        addSubview(collectionView)
    }

    // MARK: - interface
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

    // MARK: - private methods

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
        DispatchQueue.main.async {
            self.collectionView .reloadData()
        }
    }

    // get cell backgroundColor
    private func cellBackgoundColor(_ indexPath: IndexPath) -> UIColor {
        if isScrolling {
            return Constant.displayColor
        }

        return (indexPath.row == currentIndexPath.row) ? Constant.displayColor : Constant.blurColor;
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension CareerPathOccupationPickerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

    // auto scroll to nearby item/cell
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if fabs(velocity.x) >= Constant.velocity {
            print("scrollViewWillEndDragging velocity: ", velocity.x)
            let offsetX = offsetOfNearbyItem(withVelocity: velocity)
            targetContentOffset.pointee = CGPoint(x: offsetX, y: 0)
            print("scrollViewWillEndDragging offsetX: ", offsetX)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(scrollView)
    }

    // MARK: private methods
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

    // auto scroll to nearby item/cell's private methods
    // get nearby item/cell's offset-x with velocity
    private func offsetOfNearbyItem(withVelocity velocity: CGPoint) -> CGFloat {
        let direction: OccupationScrollDirection = (velocity.x < 0) ? .last : .next
        let targetIndexPath = nearbyIndexPath(direction)
        let offsetX = offsetAtIndexPath(targetIndexPath)

        return offsetX
    }

    // get nearby indexPath with OccupationScrollDirection
    private func nearbyIndexPath(_ direction: OccupationScrollDirection) -> IndexPath {
        if direction == .last,
            currentIndexPath.row > 0{
            return IndexPath(row: currentIndexPath.row - 1,
                             section: currentIndexPath.section)
        }

        if direction == .next,
            currentIndexPath.row < dataSource.count - 1{
            return IndexPath(row: currentIndexPath.row + 1,
                             section: currentIndexPath.section)
        }

        return currentIndexPath
    }

    // get nearby item/cell's offset-x with IndexPath
    private func offsetAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        let collectionViewWidth = collectionView.frame.size.width
        let viewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = viewLayout.itemSize.width
        let itemOccupiedWidth = itemWidth + viewLayout.minimumLineSpacing
        let leftEdge = (collectionView.frame.size.width - itemWidth) * 0.5

        let itemCenterX = leftEdge + itemOccupiedWidth * CGFloat(indexPath.row) + itemWidth * 0.5

        return itemCenterX - collectionViewWidth * 0.5
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
        // if velocity.x < Constant.velocity, goto proposeContentOffset's nearby item
        if fabs(velocity.x) < CareerPathOccupationPickerView.Constant.velocity {
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

        return proposedContentOffset
    }
}

// MARK: - OccupationCollectionViewCell

class OccupationCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "OccupationCollectionViewCellReuseIdentifier"

    fileprivate enum Constant {
        static let backgroundColor = UIColor.clear
        static let textColor = UIColor(white: 0.0, alpha: 0.9)
        static let textFont = UIFont.systemFont(ofSize: 20.0)
        static let textAlignment = NSTextAlignment.center
        static let cornerRadius: CGFloat = 8.0
    }

    private let label: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = Constant.backgroundColor
        label.textColor = Constant.textColor
        label.font = Constant.textFont
        label.textAlignment = Constant.textAlignment

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.frame = self.bounds
        contentView.addSubview(label)

        // round corner
        layer.cornerRadius = Constant.cornerRadius
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
