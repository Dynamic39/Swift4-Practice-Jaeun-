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
    
    //Alert기능을 어디서든지 활용할 수 있게 간소화 하여 준다.
    func alert(_ message:String, completion: (()->Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel, handler: { (_) in
                completion?() // completion의 매개변수의 값이 nil이 아닐때에만 실행되도록
            })
            alert.addAction(okAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
}
