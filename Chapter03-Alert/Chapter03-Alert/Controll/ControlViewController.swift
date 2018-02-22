//
//  ControlViewController.swift
//  Chapter03-Alert
//
//  Created by Samuel K on 2017. 11. 14..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class ControlViewController: UIViewController {

    private let slider = UISlider()
    
    var sliderValue:Int {
        let ratingValue = self.slider.value
        print(ratingValue)
        return Int(ratingValue)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slider.minimumValue = 0
        self.slider.maximumValue = 100
        
        self.slider.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        self.view.addSubview(self.slider)
        
        self.preferredContentSize = CGSize(width: self.slider.frame.width, height: self.slider.frame.height + 10)
        
    }
    
}
