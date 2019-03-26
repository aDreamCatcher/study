//
//  SlideBlockViewController.swift
//  SwiftUtilities
//
//  Created by Guiyang Li on 2019/3/25.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class SlideBlockViewController: UIViewController {

    // MARK: properties

    fileprivate var slider: CustomSlider?
    fileprivate var sliderBlockView: SlideBlockView?

    // MARK: life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSlider()
        setupSliderBlockView()

        view.backgroundColor = UIColor.gray
    }


    // MARK: private methods

    fileprivate func setupSlider() {
        let sliderFrame = CGRect(x: 20,
                                 y: 100,
                                 width: view.frame.size.width - 40,
                                 height: 50)

        slider = CustomSlider(frame: sliderFrame)
        slider?.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider?.backgroundColor = UIColor.purple
        slider?.setMinimumTrackImage(UIImage(named: "minimumTracking"), for: .normal)
        slider?.setMaximumTrackImage(UIImage(named: "maximumTracking"), for: .normal)
        slider?.minimumValueImage = UIImage(named: "minimum")
        slider?.setThumbImage(UIImage(named: "face"), for: .normal)
        slider?.maximumValueImage = UIImage(named: "maximum")
        slider?.isContinuous = false
        slider?.minimumValue = 0
        slider?.maximumValue = 2


        if let slider = slider {
            view.addSubview(slider)
        }
    }

    @objc fileprivate func sliderValueChanged(_ slider: UISlider) {
        let value = roundf(slider.value)
        slider.setValue(value, animated: true)
        print(slider)
    }

    fileprivate func setupSliderBlockView() {
        let sliderFrame = CGRect(x: 20,
                                 y: 250,
                                 width: view.frame.size.width - 40,
                                 height: 100)

        sliderBlockView = SlideBlockView(frame: sliderFrame)
        sliderBlockView?.setDataSource(["0", "1", "2"], selectedIndex: 1)
        sliderBlockView?.setScrollEndCallback({ (index) in
            print("scroll to ", index)
        })

        if let sliderBlockView = sliderBlockView {
            view.addSubview(sliderBlockView)
        }
    }
}
