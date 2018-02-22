//
//  ViewController.swift
//  Chapter02-InputForm
//
//  Created by Samuel K on 2017. 11. 1..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var pramEmail:UITextField!
    var pramUpdate:UISwitch!
    var pramInterval:UIStepper!
    var textUpdate:UILabel!
    var txtInterval:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationController?.title = "설정"
        
        let emailLB = UILabel()
        emailLB.frame = CGRect(x: 30, y: 100, width: 100, height: 30)
        emailLB.text = "Email"
        emailLB.font = UIFont.systemFont(ofSize: 14)
        
        self.view.addSubview(emailLB)
     
        let updateLB = UILabel()
        updateLB.frame = CGRect(x: 30, y: 150, width: 100, height: 30)
        updateLB.text = "자동갱신"
        updateLB.font = UIFont.systemFont(ofSize: 14)
        
        self.view.addSubview(updateLB)
        
        let intervalLB = UILabel()
        intervalLB.frame = CGRect(x: 30, y: 200, width: 100, height: 30)
        intervalLB.text = "갱신주기"
        intervalLB.font = UIFont.systemFont(ofSize: 14)
        
        self.view.addSubview(intervalLB)
        
        pramEmail = UITextField()
        pramEmail.frame = CGRect(x: 120, y: 100, width: 220, height: 30)
        pramEmail.font = UIFont.systemFont(ofSize: 13)
        pramEmail.borderStyle = UITextBorderStyle.roundedRect
        pramEmail.placeholder = "이메일 예)sky4411v@gmail.com"
        pramEmail.autocapitalizationType = .none
        
        self.view.addSubview(pramEmail)
        
        pramUpdate = UISwitch()
        pramUpdate.frame = CGRect(x: 120, y: 150, width: 50, height: 30)
        
        pramUpdate.setOn(true, animated: true)
        
        self.view.addSubview(pramUpdate)
        
        pramInterval = UIStepper()
        
        pramInterval.frame = CGRect(x: 120, y: 200, width: 50, height: 30)
        pramInterval.minimumValue = 0
        pramInterval.maximumValue = 100
        pramInterval.stepValue = 1
        pramInterval.value = 0
        
        self.view.addSubview(pramInterval)
        
        textUpdate = UILabel()
        textUpdate.frame = CGRect(x: 250, y: 150, width: 100, height: 30)
        textUpdate.font = UIFont.systemFont(ofSize: 12)
        textUpdate.textColor = UIColor.red
        textUpdate.text = "갱신함"
        
        self.view.addSubview(textUpdate)
        
        txtInterval = UILabel()
        txtInterval.frame = CGRect(x: 250, y: 200, width: 100, height: 30)
        txtInterval.font = UIFont.systemFont(ofSize: 12)
        txtInterval.textColor = UIColor.red
        txtInterval.text = "0분마다"
        
        view.addSubview(txtInterval)
        
        pramUpdate.addTarget(self, action: #selector(presentUpdataValue(_:)), for: .valueChanged)
        
        pramInterval.addTarget(self, action: #selector(presentIntervalValue(_:)), for: .valueChanged)
        
        let submitbtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(submit(_:)))
        self.navigationItem.rightBarButtonItem = submitbtn
        
        //커스텀 폰트를 적용한다.
        let cutomFont = UIFont(name: "sharky&medusa1", size: 14)
        emailLB.font = cutomFont
        
        //커스텀으로 사용가능한 폰트를 추출한다.
        
        for family in UIFont.familyNames {
            print(family)
            
            for names in UIFont.fontNames(forFamilyName: family){
                print("==\(names)")
            }
        }

    }
    
    //다른 뷰컨트롤러에 데이터를 넣어줄 메서드를 구현한다.
    @objc func submit(_ sender:Any){
        let rvc = ReadViewController()
        rvc.pEmail = pramEmail.text
        rvc.pUpdate = pramUpdate.isOn
        rvc.pInterval = pramInterval.value
        
        navigationController?.pushViewController(rvc, animated: true)
    }
    
    @objc func presentUpdataValue(_ sender:UISwitch) {
        textUpdate.text = (sender.isOn == true ? "갱신함" : "갱신하지 않음")
    }
    
    @objc func presentIntervalValue(_ sender:UIStepper) {
        self.txtInterval.text = "\(Int(sender.value))분마다"
    }
    
    
}


