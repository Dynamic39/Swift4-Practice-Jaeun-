//
//  CustomPlistViewController.swift
//  Chapter05-UserDefaults
//
//  Created by Samuel K on 2018. 2. 27..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class CustomPlistViewController: UIViewController {
    
    
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var ageLB: UILabel!
    
    var name: String?
    var age: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadToDisk()

    }
    
    
    
    func loadToDisk() {
        
        //plist를 불러온다.
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let path2 = Bundle.main.path(forResource: "data", ofType: "plist")
        if let dic = NSDictionary(contentsOfFile: path2!) as? [String:Any] {
            name = dic["이름"] as? String
            age = dic["나이"] as? Int
        }
        let plist = path.strings(byAppendingPaths: ["data.plist"])[0]
        print(plist)
        let data = NSMutableDictionary(contentsOfFile: plist)
        
        //읽어온 값을 로딩한다.
//        name = data?.value(forKey: "이름") as? String
//        age = data?.value(forKey: "나이") as? Int
        
        nameLB.text = name
        ageLB.text = String(describing: age)
        
        
    }

}
