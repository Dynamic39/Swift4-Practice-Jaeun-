//
//  CSTabBarController.swift
//  Chapter03-CSTabBar
//
//  Created by Samuel K on 2017. 11. 28..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class CSTabBarController: UITabBarController {
    
    let csView = UIView()
    let tabItem01 = UIButton(type: .system)
    let tabItem02 = UIButton(type: .system)
    let tabItem03 = UIButton(type: .system)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //기존 설정된 탭바를 숨김처리 한다.
        self.tabBar.isHidden = true
        
        //새로운 설정을 위한 탭바를 만들어 준다.
        let width = self.view.frame.width
        let height: CGFloat = 50
        let x:CGFloat = 0
        let y = self.view.frame.height - height
        
        self.csView.frame = CGRect(x: x, y: y, width: width, height: height)
        self.csView.backgroundColor = UIColor.brown
        
        self.view.addSubview(csView)
        
        // 버튼의 너비와 높이를 설정한다.
        
        let tabBtnWidth = self.csView.frame.size.width / 3
        let tabBtnHeight = self.csView.frame.height
        
        // 버튼의 영억을 차레로 설정한다.
        
        self.tabItem01.frame = CGRect(x: 0, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem02.frame = CGRect(x: tabBtnWidth, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem03.frame = CGRect(x: tabBtnWidth*2, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        
        self.addTabBarBtn(btn: tabItem01, title: "첫번째 버튼", tag: 0)
        self.addTabBarBtn(btn: tabItem02, title: "두번째 버튼", tag: 1)
        self.addTabBarBtn(btn: tabItem03, title: "세번째 버튼", tag: 2)
        
        //초기화면을 첫번째 화면으로 지정하여 주는 메서드를 구현한다.
        self.onTabBarItem(self.tabItem01)
        
   
    }
    
    //버튼에 공통적으로 들어갈 속성을 설정하는 메서드를 구현한다.
    
    func addTabBarBtn(btn: UIButton, title:String, tag:Int) {
        
        btn.setTitle(title, for: .normal)
        btn.tag = tag
        
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.yellow, for: .selected)
        
        btn.addTarget(self, action: #selector(onTabBarItem), for: .touchUpInside)
        self.csView.addSubview(btn)

    }
    
    @objc func onTabBarItem(_ sender:UIButton){
        self.tabItem01.isSelected = false
        self.tabItem02.isSelected = false
        self.tabItem03.isSelected = false
        
        sender.isSelected = true
        
        //Tag별로 선택된 ViewController에 이동 될 수 있도록 하여준다.
        self.selectedIndex = sender.tag
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
