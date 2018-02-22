//
//  ViewController.swift
//  Chapter03-TabBar
//
//  Created by Samuel K on 2017. 11. 13..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
        title.text = "첫번째 탭"
        title.textColor = .red
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.sizeToFit()
        title.center.x = self.view.frame.width / 2
        
        self.view.addSubview(title)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tabBar = self.tabBarController?.tabBar
        tabBar?.isHidden = (tabBar?.isHidden == true) ? false : true
        //애니메이션 효과로 자연스럽게 바꿔줌
        
//        UIView.animate(withDuration: TimeInterval(0.5)) {
//            //tabBar?.alpha = (tabBar?.alpha == 0 ? 1:0)
//            tabBar?.alpha = (tabBar?.alpha == 1 ? 0:1)
//
//        }
        
        func exec() {
            tabBar?.alpha = (tabBar?.alpha == 0 ? 1:0)
        }
        
        UIView.animate(withDuration: 0.5, animations: exec)
        
    }

    
    
}

