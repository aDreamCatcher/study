//
//  SelectCell.swift
//  shares
//
//  Created by Guiyang Li on 2019/3/1.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class SelectCell: UICollectionViewCell {

    public static let reuseID = "shareSelectCellReuseIdentifier"

    private let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.gray
        label.textColor = UIColor.black

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        label.frame = bounds
    }

    func configure() {
        self.backgroundColor = UIColor.yellow
        contentView.backgroundColor = UIColor.green
    }
}

// MARK: - Interfaces
extension SelectCell {
    public func setText(_ text: String) {
        label.text = text
    }
}
