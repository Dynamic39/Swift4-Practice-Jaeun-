//
//  AppDelegate.swift
//  Chapter03-TabBar
//
//  Created by Samuel K on 2017. 11. 13..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //탭바 컨트롤러의 경우, 각각의 ViewDidLoad에 진행할시, 처음에 화면이 나타나지 않는 단점이 있다.
        //그러므로, 앱 딜리게이트의 현 위치에서 각각의 탭 바 컨트롤러를 확인하여 준다.
        
        //1. 루트뷰 컨트롤러를 UITabBarController 로 캐스팅 하여 준다.
        if let tbC = self.window?.rootViewController as? UITabBarController {
            
            if let tbItems = tbC.tabBar.items {
//                tbItems[0].image = UIImage(named: "calendar")
//                tbItems[1].image = UIImage(named: "file-tree")
//                tbItems[2].image = UIImage(named: "photo")
                
                tbItems[0].title = "Calendar"
                tbItems[1].title = "File"
                tbItems[2].title = "Photo"
                
                tbItems[0].image = UIImage(named: "designbump")?.withRenderingMode(.alwaysOriginal)
                tbItems[1].image = UIImage(named: "rss")?.withRenderingMode(.alwaysOriginal)
                tbItems[2].image = UIImage(named: "facebook")?.withRenderingMode(.alwaysOriginal)
                
                for tbItem in tbItems {
                    let image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysOriginal)
                    tbItem.selectedImage = image
                }
                
                //프록시 객체를 이용하여 아이템의 타이틀 색상을 조절
                
                let tbItemProxy = UITabBarItem.appearance()
                
                tbItemProxy.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.red], for: .selected)
                
                tbItemProxy.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.gray], for: .disabled)
                
                tbItemProxy.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont.systemFont(ofSize: 15)], for: .normal)
                
                
                
            }
            
 //           let backImge = UIImage(named: "connectivity-bar")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
            
//            tbC.tabBar.tintColor = UIColor.white
//          tbC.tabBar.backgroundImage = UIImage(named: "menubar-bg-mini")
//            tbC.tabBar.backgroundImage = UIImage(named: "connectivity-bar")
//            tbC.tabBar.backgroundImage = backImge
//            tbC.tabBar.barTintColor = UIColor.blue
            
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

