//
//  ReadViewController.swift
//  Chapter02-InputForm
//
//  Created by Samuel K on 2017. 11. 8..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class ReadViewController: UIViewController {

    
    var pEmail:String?
    var pUpdate:Bool?
    var pInterval:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let email = UILabel()
        let update = UILabel()
        let interval = UILabel()
        
        email.frame = CGRect(x: 50, y: 100, width: 300, height: 30)
        update.frame = CGRect(x: email.frame.origin.x, y: 150, width: 300, height: 30)
        interval.frame = CGRect(x: email.frame.origin.x, y: 200, width: 300, height: 30)
        
        //다른 뷰 컨트롤러에서 전달 받은 값을 넘겨준다
        email.text = "전달 받은 이메일 : \(pEmail!)"
        update.text = "업데이트 여부 : \(pUpdate == true ? "업데이트 함" : "업데이트 안함")"
        interval.text = "업데이트 주기 \(pInterval!)분마다"

        view.addSubview(email)
        view.addSubview(update)
        view.addSubview(interval)

    }

}
