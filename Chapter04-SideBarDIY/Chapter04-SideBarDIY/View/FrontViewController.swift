//
//  FrontViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by Samuel K on 2018. 2. 22..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController {
    
    //델리게이트 패턴을 사용하여, 클래스 내에 어디서든 참조가 가능하도록 한다.
    var delegate: RevealViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //버튼 만들기
        leftSideBarOpenButtonCreate()
        

    }
    
    //액션을 실행한 변수를 시행한다.
    @objc func moveSide(_ sender: Any) {
        
        if self.delegate?.isSideBarShowing == false {
            self.delegate?.openSideBar(nil) // 사이드바 오픈
        } else {
            self.delegate?.closeSideBar(nil) // 사이드 바 닫기
        }
        
    }
    
    func leftSideBarOpenButtonCreate() {
        //사이드 바 오픈용 버튼 정의
        let btnSideBar = UIBarButtonItem(image: UIImage(named: "sidemenu.png"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(moveSide(_:)))
        
        //버튼 왼쪽 영역에 추가
        self.navigationItem.leftBarButtonItem = btnSideBar
    }

}
