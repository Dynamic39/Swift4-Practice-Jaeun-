//
//  DepartPickerVC.swift
//  Chapter06-HR
//
//  Created by Samuel K on 2018. 3. 8..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

//사원등록 알람창에 픽커뷰 삽입
class DepartPickerVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //DAO 객체 및 데이터 소스 변수 설정
    let departDAO = DepartmentDAO()
    typealias SpecificDepartType = (departCd:Int, departTitle: String, departAddr: String)
    var departList:[SpecificDepartType]!
    var pickerView: UIPickerView!
    
    //현재 피커뷰에 선택되어 있는 부서 코드를 가져온다.
    var selectedDepartCd:Int {
        let row = self.pickerView.selectedRow(inComponent: 0)
        
        return self.departList[row].departCd
    }
    
    //MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. DB에서 부서 목록을 가져와 튜플 배열을 초기화 한다.
        self.departList = self.departDAO.find()
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.view.addSubview(self.pickerView)
        
        //2. 외부에서 viewController를 참조할때 사이즈
        let pWidth = self.pickerView.frame.width
        let pHeight = self.pickerView.frame.height
        self.preferredContentSize = CGSize(width: pWidth, height: pHeight)
        
    }
    
    //MARK: - PickerView Delegate Method
    
    //전체 컴포넌트 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //특정 컴포넌트의 행 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.departList.count
    }
    //피커뷰의 각 행에 표시될 뷰를 결정하는 메서드
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        //컴포넌트의 속성을 조정하여 준다.
        let titleView = view as? UILabel ?? {
            let titleView = UILabel()
            titleView.font = UIFont.systemFont(ofSize: 14)
            titleView.textAlignment = .center
            return titleView
            }()
        
        titleView.text = "\(self.departList[row].departTitle)(\(self.departList[row].departAddr))"
        
        return titleView
        
    }
    
    
}

