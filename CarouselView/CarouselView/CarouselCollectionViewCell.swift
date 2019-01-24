//
//  CarouselCollectionViewCell.swift
//  CarouselView
//
//  Created by lgy on 2019/1/23.
//  Copyright © 2019 lgy. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "CarouselCollectionViewCellReuseIdentifier"

    private let label: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.textAlignment = .center

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.frame = self.bounds
        
        contentView.addSubview(label)
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
