//
//  ViewController.swift
//  Chapter03-CSStepper
//
//  Created by Samuel K on 2017. 11. 28..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //프로그래밍 방식으로 CSStepper 정의
        let stepper = CSStepper()
        stepper.frame = CGRect(x: 30, y: 100, width: 130, height: 30)
        
        stepper.rightTitle = "Up"
        stepper.leftTitle = "Down"
        stepper.stepValue = 2
        
        self.view.addSubview(stepper)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

