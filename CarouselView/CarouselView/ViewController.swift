//
//  ViewController.swift
//  CarouselView
//
//  Created by lgy on 2019/1/23.
//  Copyright © 2019 lgy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let width = view.bounds.size.width
        let carouselView = CarouselView(CGRect(x: 0, y: 100, width: width, height: 200),
                                        itemSize: CGSize(width: 200,
                                                         height: 200),
                                        itemSpace: 50,
                                        dataSource: ["this is one", "this is two", "this is three"])

        carouselView.backgroundColor = UIColor.gray
        
        view.addSubview(carouselView)
    }


}

