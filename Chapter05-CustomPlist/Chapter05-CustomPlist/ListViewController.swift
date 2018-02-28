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
    
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var genderSG: UISegmentedControl!
    @IBOutlet weak var marriedSW: UISwitch!
    
    var toolBar:UIToolbar?
    var accountList = [String]()
    
    override func viewDidLoad() {
        
        //피커뷰 인스턴스 생성
        let picker = UIPickerView()
        picker.delegate = self
        //accout 텍스트 필드 입력방식을 피커뷰로 변경
        self.accountTF.inputView = picker
        
        makeToolbarOnthePickerView()
        makePickerDoneBtn()
        
    }
    
    //UserDefaults 에 데이터 저장
    @IBAction func changeMarried(_ sender: UISwitch) {
        
        let value = sender.isOn // T and F
        let plist = UserDefaults.standard
        
        plist.set(value, forKey: "married")
        plist.synchronize()
        
    }
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        
        let value = sender.selectedSegmentIndex // 0, 1
        let plist = UserDefaults.standard
        
        plist.set(value, forKey: "gender")
        plist.synchronize()
        
    }
    
    
    func makeToolbarOnthePickerView() {
        toolBar = UIToolbar()
        toolBar?.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        toolBar?.barTintColor = UIColor.lightGray
        
        self.accountTF.inputAccessoryView = toolBar
    }
    
    func makePickerDoneBtn() {
        //완료버튼 만들기
        let done = UIBarButtonItem()
        done.title = "Done"
        done.target = self
        done.action = #selector(pickerDone(_:))
        
        //새롭게 등록하는 버튼을 만든다
        let newBtn = UIBarButtonItem()
        newBtn.title = "New"
        newBtn.target = self
        newBtn.action = #selector(newAccount(_:))
        
        //오른쪽으로 버튼이 위치하도록 가변 값을 넣어줌
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //버튼을 툴바에 추가
        //가변 공간을 넣기 위해선 아이템 셋의 순서가 중요하다. (가변 공간을 앞에 배치해주면 오른쪽 정렬, 왼쪽에 배치해주면 왼쪽 정렬)
        toolBar?.setItems([newBtn ,flexSpace, done], animated: true)
    }
    
    @objc func pickerDone(_ sender:Any){
        self.view.endEditing(true)
    }
    
    @objc func newAccount(_ sender:Any) {
        //픽커 닫기
        self.view.endEditing(true)
        
        //알림창 객체 생성
        let alert = UIAlertController(title: "새 계정을 입력하세요!", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "ex) abc@gmail.com"
        }
        //액션 동작 설정
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            //옵셔널 처리
            if let account = alert.textFields?.first?.text {
                self.accountList.append(account)
                self.accountTF.text = account
                
                //컨트롤 값을 초기화 한다.
                self.nameLB.text = ""
                self.genderSG.selectedSegmentIndex = 0
                self.marriedSW.isOn = false
                
            }
        }
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //row component의 개수를 정의한다.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return accountList.count
    }
    // 실제로 컨포넌트에 어떤 값이 들어오는지 작성한다.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return accountList[row]
    }
    
    //선택된 컨포넌트 row를 어떻게 처리할지 확인한다.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //계정 선택된 리스트를 텍스트필드에 넣어줌
        let account = self.accountList[row] // 선택된 계정
        self.accountTF.text = account
        
        //피커뷰 닫음
        //self.view.endEditing(true)
        
    }
    
    //테이블 뷰 내용정리
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
            alert.addTextField() {
                $0.text = self.nameLB.text // 기본값 넣어주기
            }
            
            let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                let value = alert.textFields?.first?.text
                
                let plist = UserDefaults.standard
                plist.set(value, forKey: "name")
                
                self.nameLB.text = value
                
                plist.synchronize()
            })
            
            alert.addAction(action)
            self.present(alert, animated: false, completion: nil)
        }
        
    }
}



    

