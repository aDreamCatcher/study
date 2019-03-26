//
//  CustomSlider.swift
//  SwiftUtilities
//
//  Created by Guiyang Li on 2019/3/26.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {

    fileprivate var lineBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(lineBackgroundView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func minimumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        let minimumFrame = super.minimumValueImageRect(forBounds: bounds)
        print("minimumValueImageRect: ", minimumFrame)
        return minimumFrame
    }

    open override func maximumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        let maximumFrame = super.maximumValueImageRect(forBounds: bounds)
        print("maximumValueImageRect: ", maximumFrame)
        return maximumFrame
    }

    open override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let trackFrame = super.trackRect(forBounds: bounds)

        var minimumImageWidth: CGFloat = 0
        var maximumImageWidth: CGFloat = 0

        if let minimumImage = minimumValueImage {
            minimumImageWidth = minimumImage.size.width
        }
        if let maximumImage = maximumValueImage {
            maximumImageWidth = maximumImage.size.width
        }

        let desitionFrame = CGRect(x: minimumImageWidth,
                                   y: trackFrame.origin.y,
                                   width: bounds.size.width - minimumImageWidth - maximumImageWidth,
                                   height: trackFrame.size.height)
        print("trackRect: ", desitionFrame)
        return desitionFrame
    }

    open override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let thumbFrame = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        print("thumbRect: ", bounds, " trackRect: ", rect, " value: ", value, " --- thumbFrame:  ", thumbFrame)
        return thumbFrame
    }

}
