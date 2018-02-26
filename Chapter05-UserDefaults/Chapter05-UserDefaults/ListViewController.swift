//
//  ListViewController.swift
//  Chapter05-UserDefaults
//
//  Created by Samuel K on 2018. 2. 26..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    //아웃렛을 연결하여 줌
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var marriedSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //plist에 저장한 사항들이 변동되지 않고 보일 수 있도록 해준다.
        let plist = UserDefaults.standard
        self.nameLB.text = plist.string(forKey: "name") // 이름
        self.marriedSwitch.isOn = plist.bool(forKey: "married") // 결혼 여부
        self.genderSegment.selectedSegmentIndex = plist.integer(forKey: "gender") // 성별

    }
    
    @IBAction func chageGender(_ sender: UISegmentedControl) {
        //성별 바꿔주기
        let value = sender.selectedSegmentIndex
        let plist = UserDefaults.standard // 기본 저장소 로드
        plist.set(value, forKey: "gender")
        //동기화 처리 진행, 메모리에 직접 입력이기에 에러날 확률은 적지만, 싱크로를 해주는 것이 좋다.
        plist.synchronize()
        
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        
        let value = sender.isOn
        let plist = UserDefaults.standard
        plist.set(value, forKey: "married") // 새로운 키값으로 저장한다.
        plist.synchronize()
        
    }
    
    
}

extension ListViewController {
    
    //각 row의 선택별로 적절한 값을 주기위한 메서드를 추가한다.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //이름 창 띄우기
        if indexPath.row == 0 {
            //얼럿 컨트롤러 실행
            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
            //텍스트 필드 추가
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = self.nameLB.text
            })
            //액션 추가
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                // 바뀐 내용을 추가해줌
                let value = alert.textFields?[0].text
                let plist = UserDefaults.standard
                
                plist.setValue(value, forKey: "name")
                plist.synchronize()
                
                //바뀐 내용을 이름 레이블에도 적용하여 준다.
                self.nameLB.text = value
                
            }))
            //보여주기
            self.present(alert, animated: false, completion: nil)
        }
        
    }
    
    //Static type을 사용하기 때문에, 추가로 지정하여 주지 않아도 된다.
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        //스토리 보드가 변경됨에 따라 자동으로 인식하여 추가하여 준다.
//        return super.tableView(tableView, numberOfRowsInSection: section)
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        return UITableViewCell()
//
//    }
    
}
