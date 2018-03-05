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
    
    //기본 템플릿을 사용하기 위하여 변수를 선언한다.
    //읽기 전용이므로 Mutable을 사용해서는 안된다.
    var defaultsPList: NSDictionary!
    
    override func viewDidLoad() {
        
        //피커뷰 인스턴스 생성
        let picker = UIPickerView()
        picker.delegate = self
        //accout 텍스트 필드 입력방식을 피커뷰로 변경
        self.accountTF.inputView = picker
        
        makeToolbarOnthePickerView()
        makePickerDoneBtn()
        makeNavigationBtnHandler()
        loadToApp()
        
        //메인번들에서 UserInfo Plist를 읽어온다.
        if let defaultsPlistPath = Bundle.main.path(forResource: "UserInfo", ofType: "plist")
        {
            self.defaultsPList = NSDictionary(contentsOfFile: defaultsPlistPath)
        }
        
        
    }
    
    
    func loadToApp() {
        
        let plist = UserDefaults.standard
        //저장된 배열 불러오기 아니면 초기화
        let accountlist = plist.array(forKey: "accountlist") as? [String] ?? [String]()
        self.accountList = accountlist
        
        //selectedAccount가 있는 경우만 해당됨
        if let account = plist.string(forKey: "selectedAccount") {
            self.accountTF.text = account
            
            //경로 가지고 오기
            let customPlist = "\(account).plist" // 읽어올 파일명
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            
            //경로를 딕셔너리 형태로 바꿔주기(수정이 불가능한 객체를 처음에 로드해준다.)
            let data = NSDictionary(contentsOfFile: clist)
            
            self.nameLB.text = data?["name"] as? String
            self.genderSG.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.marriedSW.isOn = data?["married"] as? Bool ?? false
            
        }
        
        //계정 정보가 없는 경우 막아 줄 수 있음
        if (self.accountTF.text?.isEmpty)! {
            self.accountTF.placeholder = "등록된 계정이 없습니다."
            self.genderSG.isEnabled = false
            self.marriedSW.isEnabled = false
        }
        
    }
    
    //UserDefaults 에 데이터 저장
    @IBAction func changeMarried(_ sender: UISwitch) {
        
        let value = sender.isOn // T and F
        
        //저장 로직
        //1. 읽어올 파일명 정리
        let customPlist = "\(self.accountTF.text!).plist"
        //2. 디렉토리 경로 찾기
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        //3. 프로퍼티 객체를 읽어옴
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        //4. 딕셔너리 객체로 변환, 없을시 새로 만들어줌
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: defaultsPList)
        
        data.setValue(value, forKey: "married")
        data.write(toFile: plist, atomically: true)
        
        print("Custom Plist 확인 결혼 여부 = ", plist)
        
    }
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        
        let value = sender.selectedSegmentIndex // 0, 1

        //저장 로직
        //1. 읽어올 파일명 정리
        let customPlist = "\(self.accountTF.text!).plist"
        //2. 디렉토리 경로 찾기
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        //3. 프로퍼티 객체를 읽어옴
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        //4. 딕셔너리 객체로 변환, 없을시 새로 만들어줌
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: defaultsPList) // 기본값을 넣어준다. 읽기 전용이기 때문에 Mutable인스턴스를 사용하여 초기화 하여 준다.
        
        data.setValue(value, forKey: "gender")
        data.write(toFile: plist, atomically: true)
        
    }
    
    func makeNavigationBtnHandler () {
        
        let addBtn = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(newAccount(_:)))

        self.navigationItem.rightBarButtonItems = [addBtn]
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
        
        //옵셔널 타입을 이용하여 진행
        if let account = self.accountTF.text
        {
            //경로 가지고 오기
            let customPlist = "\(account).plist" // 읽어올 파일명
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            
            //경로를 딕셔너리 형태로 바꿔주기(수정이 불가능한 객체를 처음에 로드해준다.)
            let data = NSDictionary(contentsOfFile: clist)
            
            self.nameLB.text = data?["name"] as? String
            self.genderSG.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.marriedSW.isOn = data?["married"] as? Bool ?? false
        }
        
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
                
                //계정을 다시 활성화 처리하여 준다
                self.genderSG.isEnabled = true
                self.marriedSW.isEnabled = true
                
                //계정목록을 통채로 저장한다.
                let plist = UserDefaults.standard
                
                plist.set(self.accountList, forKey: "accountlist")
                plist.set(account, forKey: "selectedAccount")
                plist.synchronize()
                
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
        
        //계정을 생성하면 이게정을 선택한 것으로 간주하고 저장한다.
        let plist = UserDefaults.standard
        plist.set(account, forKey: "selectedAccount")
        plist.synchronize()
        
        //피커뷰 닫음
        //self.view.endEditing(true)
        
    }
    
    //테이블 뷰 내용정리
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 && !(self.accountTF.text?.isEmpty)! {
            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
            alert.addTextField() {
                $0.text = self.nameLB.text // 기본값 넣어주기
            }
            
            let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                let value = alert.textFields?.first?.text
                
                //저장 로직을 위해 주석처리
//                let plist = UserDefaults.standard
//                plist.set(value, forKey: "name")
//                plist.synchronize()
                
                //저장 로직
                //1. 읽어올 파일명 정리
                let customPlist = "\(self.accountTF.text!).plist"
                //2. 디렉토리 경로 찾기
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] as NSString
                //3. 프로퍼티 객체를 읽어옴
                let plist = path.strings(byAppendingPaths: [customPlist]).first!
                //4. 딕셔너리 객체로 변환, 없을시 새로 만들어줌
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultsPList)
                
                data.setValue(value, forKey: "name")
                data.write(toFile: plist, atomically: true)
                
                
                self.nameLB.text = value
            })
            
            alert.addAction(action)
            self.present(alert, animated: false, completion: nil)
        }
        
    }
}



    

