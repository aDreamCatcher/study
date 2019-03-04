//
//  BaseCollectionViewCell.swift
//  SwiftUtilities
//
//  Created by Guiyang Li on 2019/3/4.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    public static let reuseID = "BaseCollectionViewCellIdentifier"

    private let label: UILabel = {
        let lab = UILabel()
        lab.backgroundColor = UIColor.gray
        lab.textColor = UIColor.black

        return lab
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.frame = bounds

        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - interfaces
extension BaseCollectionViewCell {
    public func setText(_ text: String) {
        label.text = text
    }
}
