//
//  ViewController.swift
//  CarouselView
//
//  Created by lgy on 2019/1/23.
//  Copyright © 2019 lgy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    public let carouselView = CarouselView(CGRect.zero,
                                           dataSource: ["this is one", "this is two", "this is three"]) { (index) in
                                            print("Carousel Scroll End - ", index)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(carouselView)
        
        carouselView.frame = CGRect(x: 0, y: 100, width: 375, height: 110)
        
        
        let button = UIButton(frame: CGRect(x: 100, y: 350, width: 50, height: 50))
        button.setTitle("click", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        view.addSubview(button)
        
        view.backgroundColor = UIColor.gray
    }

    @objc func click() {
        carouselView.scroll(.next)
    }

}

