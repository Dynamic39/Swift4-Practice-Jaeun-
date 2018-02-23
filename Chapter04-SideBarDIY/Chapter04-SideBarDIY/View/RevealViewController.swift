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
        
        self.setupView()
        
    }
    
    //초기화면 설정
    func setupView() {
        //프론트 컨트롤러 객체를 읽어 온다.(네비게이션 컨트롤러 형태로 불러와야, 네비게이션 컨트롤러를 함께 사용할 수 있다.)
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_front") as? UINavigationController {
            //읽어온 컨트롤러를 클래스 전체에서 참조할 수 있도록 속성 저장
            self.contentVC = vc
            //프론트 컨트롤러 객체를 메인 컨트롤러의 자식으로 등록
            self.addChildViewController(vc)
            //프론트 컨트롤러 뷰를 메인컨트롤러 서브 뷰로 등록
            self.view.addSubview(vc.view)
            //프론트 컨트롤러에 부모뷰 컨트롤러가 바뀌었음을 알려준다.
            vc.didMove(toParentViewController: self)
            
            //프론트 컨트롤의 델리게이트 변수에 참조 정보를 넣어줌
            let frontVC = vc.viewControllers[0] as? FrontViewController
            frontVC?.delegate = self
            
        }
    }
    
    //사이드바 뷰 로딩
    func getSideView() {
        
        //사이드바 컨트롤러 객체 읽어오기
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_rear") {
            //다른 메소드에서 참조 가능하게 속성에 저장
            self.sideVC = vc
            //컨테이너 뷰 컨트롤러에 연결
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            //부모뷰 컨트롤러가 바뀌었음을 알려줌
            vc.didMove(toParentViewController: self)
            //프론트 컨트롤뷰를 가장 위로 올린다.
            self.view.bringSubview(toFront: (self.contentVC?.view)!)
        }
    }
    
    //컨텐츠 뷰에 그림자 효과
    func setShadowEffect(shadow: Bool, offset: CGFloat) {
        
        //그림자 효과
        if (shadow == true) {
            self.contentVC?.view.layer.cornerRadius = 10 // 그림자 모서리
            self.contentVC?.view.layer.shadowOpacity = 0.8 // 그림자 투명도
            self.contentVC?.view.layer.shadowColor = UIColor.black.cgColor // 그림자 색상
            self.contentVC?.view.layer.shadowOffset = CGSize(width: offset, height: offset) // 그림자 크기
        } else {
            self.contentVC?.view.layer.cornerRadius = 0.0
            self.contentVC?.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        
    }
    
    //사이드바 오픈
    func openSideBar(_ complete: (() -> Void)? ) {
        
        //앞에 정의한 메서드 실행
        self.getSideView() // 사이드 뷰 실행
        self.setShadowEffect(shadow: true, offset: -2)
        
        //애니매이션 옵션
        let options = UIViewAnimationOptions([.curveEaseInOut, .beginFromCurrentState])
        //애니매이션 실행
        UIView.animate(withDuration: TimeInterval(self.SLIDE_TIME),
                       delay: TimeInterval(0),
                       options: options,
                       animations: {
                        self.contentVC?.view.frame = CGRect(x: self.SIDEBAR_WIDTH, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: {
            if $0 == true {
                self.isSideBarShowing = true // 열림상태 플래그 변경
                complete?() // 함수 완료 처리
            }
        })
    }
    
    //사이드바 close
    func closeSideBar(_ complete: (() -> Void)?) {
        
        let options = UIViewAnimationOptions([.curveEaseInOut, .beginFromCurrentState])
        //애니매이션 실행
        UIView.animate(withDuration: TimeInterval(self.SLIDE_TIME),
                       delay: TimeInterval(0),
                       options: options, animations: {
                        self.contentVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        },
                       //완료후 작업 진행
                       completion: {
                        if $0 == true {
                            
                            self.sideVC?.view.removeFromSuperview() // 사이드바 제거
                            self.sideVC = nil
                            self.isSideBarShowing = false // 닫힘상태로 플래그 변경
                            self.setShadowEffect(shadow: false, offset: 0) // 그림자 효과 삭제
                            complete?() // 함수 완료처리
                            
                        }
        })
        
    }
    
}

