//
//  FrontViewController.swift
//  Chapter04-SideBar
//
//  Created by Samuel K on 2018. 2. 22..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController {

    //사이드 바 버튼 생성
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let revealVC = self.revealViewController() {
            //버튼이 클릭 될 때, 메인컨트롤러에 정의된 reavealToggle이 호출되도록 한다.
            self.sideBarButton.target = revealVC
            self.sideBarButton.action = #selector(revealVC.revealToggle(_:))
            //제스쳐를 뷰에 추가한다.
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
        
        
    }
}
