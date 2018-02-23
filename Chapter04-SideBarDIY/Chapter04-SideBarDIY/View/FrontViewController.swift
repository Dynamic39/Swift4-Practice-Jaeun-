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
        dragGesture()
        
    }
    
    //액션을 실행한 변수를 시행한다.
    @objc func moveSide(_ sender: Any) {
        
        if sender is UIScreenEdgePanGestureRecognizer {
            self.delegate?.openSideBar(nil)
        } else if sender is UISwipeGestureRecognizer {
            self.delegate?.closeSideBar(nil)
        } else if sender is UIBarButtonItem {
            if self.delegate?.isSideBarShowing == false {
                self.delegate?.openSideBar(nil)
            } else {
                self.delegate?.closeSideBar(nil)
            }
        }
        
    }
    
    
    func dragGesture() {
        
            //열기 제스쳐
            let dragLeft = UIScreenEdgePanGestureRecognizer(target: self,
                                                            action: #selector(moveSide(_:)))
            dragLeft.edges = UIRectEdge.left // 시작모서리 왼쪽
            self.view.addGestureRecognizer(dragLeft) // 뷰에 객체 등록
        
            //닫기 제스쳐
            let dragRight = UISwipeGestureRecognizer(target: self,
                                                             action: #selector(moveSide(_:)))
            dragRight.direction = .left
            self.view.addGestureRecognizer(dragRight) // 뷰에 제스처 객체를 등록
        
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
