//
//  Utils.swift
//  MyMemory
//
//  Created by Samuel K on 2018. 3. 6..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import Foundation


extension UIViewController {
    
    //Tutorial storyboard를 쉽게 만들기 위하여 extension을 사용하여, UIViewController를 확장하여 준다.
    var turorialSB: UIStoryboard {
        return UIStoryboard(name: "Tutorial", bundle: Bundle.main)
    }
    
    func instanceTutorialVC(name: String) -> UIViewController? {
        return self.turorialSB.instantiateViewController(withIdentifier: name)
    }
    
}
