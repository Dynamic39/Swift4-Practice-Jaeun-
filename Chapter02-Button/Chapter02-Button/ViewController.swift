//
//  ViewController.swift
//  Chapter02-Button
//
//  Created by Samuel K on 2017. 11. 1..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var btnChecker:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(type: UIButtonType.system)
        btn.frame = CGRect(x: 50, y: 100, width: 150, height: 30)
        btn.setTitle("테스트 버튼", for: UIControlState.normal)
        btn.center = CGPoint(x: self.view.frame.width/2, y: 100)
        self.view.addSubview(btn)
        
        btn.addTarget(self, action: #selector(btnOnClick(_:)), for: .touchUpInside)
    }
    
    @objc func btnOnClick(_ sender:Any) {
        
        if let btn = sender as? UIButton{
            
            if btnChecker {
                btn.setTitle("클릭되었습니다.", for: .normal)
                btnChecker = false
            } else {
                btn.setTitle("테스트 버튼", for: .normal)
                btnChecker = true
            }
        }
        
    }

}

