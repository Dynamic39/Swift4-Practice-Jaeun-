//
//  ListViewController.swift
//  Chapter05-CustomPlist
//
//  Created by Samuel K on 2018. 2. 28..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    

    @IBOutlet weak var accountTF: UITextField!
    
    override func viewDidLoad() {
        
        //피커뷰 인스턴스 생성
        let picker = UIPickerView()
        picker.delegate = self
        
        //accout 텍스트 필드 입력방식을 피커뷰로 변경
        self.accountTF.inputView = picker
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
