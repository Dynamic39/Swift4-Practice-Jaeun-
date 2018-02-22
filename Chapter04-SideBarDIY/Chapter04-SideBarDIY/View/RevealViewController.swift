//
//  RevealViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by Samuel K on 2018. 2. 22..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class RevealViewController: UIViewController {
    
    //각각의 역할을 하는 프로퍼티를 지정한다.
    var contentVC: UIViewController? // 콘텐츠 뷰 컨트롤러
    var sideVC: UIViewController? // 사이드바 매뉴 담당 뷰 컨트롤러
    
    var isSideBarShowing = false // 현재 사이드바 표시 여부
    
    let SLIDE_TIME = 0.3 // 사이드바 열림 / 닫힘 시간
    let SIDEBAR_WIDTH: CGFloat = 260 // 사이드바 너비

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //초기화면 설정
    func setupView() {
        
    }
    
    //사이드바 뷰 로딩
    func getSideView() {
        
    }
    
    //컨텐츠 뷰에 그림자 효과
    func setShadowEffect() {
        
    }
    
    //사이드바 오픈
    func openSideBar() {
        
    }
    
    //사이드바 close
    func closeSideBar() {
        
    }
    
}
