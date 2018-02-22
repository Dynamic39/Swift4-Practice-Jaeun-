//
//  NewAppDelegate.swift
//  Chapter03-TabBar
//
//  Created by Samuel K on 2017. 11. 13..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import Foundation
import UIKit
@UIApplicationMain

class NewAppDelegate: UIResponder, UIApplicationDelegate  {
    
    var window: UIWindow?
    
    //새로운 딜리게이트 매서드를 통하여, 코드 작업을 진행한다.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        //탭바 컨트롤러를 선언하고, 하얀색 배경화면을 씌운다.
        let tbC = UITabBarController()
        tbC.view.backgroundColor = .white
        
        //생성된 tbC를 루트뷰 컨트롤러로 지정한다.
        self.window?.rootViewController = tbC
        
        //각탭바 아이템에 루트뷰 컨트롤러 객체를 생성한다.
        
        let view01 = ViewController()
        let view02 = SecondViewController()
        let view03 = ThirdViewController()
        
        //생성된 뷰 컨트롤러 객체들을 탭바 컨트롤러에 등록한다.
        
        tbC.setViewControllers([view01, view02, view03], animated: false)
        
        // 개별 탭바 아이템의 속성은 설정한다.
        view01.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(named: "calendar"), selectedImage: nil)
        view02.tabBarItem = UITabBarItem(title: "File", image: UIImage(named: "file-tree"), selectedImage: nil)
        view03.tabBarItem = UITabBarItem(title: "Photo", image: UIImage(named: "photo"), selectedImage: nil)
        
        return true
    }
    
    
    
}
