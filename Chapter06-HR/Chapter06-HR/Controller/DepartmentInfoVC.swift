//
//  DepartmentInfoVC.swift
//  Chapter06-HR
//
//  Created by Samuel K on 2018. 3. 8..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class DepartmentInfoVC: UITableViewController {
    
    //부서 정보를 저장할 데이터 타입
    typealias DepartRecord = (departCd:Int, departTitle:String, departAddr:String)
    //부서 목록에서 넘겨 받을 부서 코드
    var departCd: Int!
    //DAO객체 생성
    let departDAO = DepartmentDAO()
    let empDAO = EmployeeDAO()
    
    //부서 정보와 사원목록을 담을 멤버변수
    //typealias 를 사용시 "!" 기재에 주의한다. 인자가 읽히지 않는 경우가 생긴다.
    var departInfo: DepartRecord!
    var empList:[EmployeeVO]!
    
    typealias name = (firstname:String, lastname:String)
    var sampleTest:name!
    
    override func viewDidLoad() {
        //super.viewDidLoad()
    
        //부서 상세 정보 및 소속 부서원을 가지고 옴
        self.departInfo = self.departDAO.get(departCd: self.departCd)
        self.empList = self.empDAO.find(departCd: self.departCd)
        self.navigationItem.title = "\(self.departInfo.departTitle)"
        
    }
    
    // MARK: - @objc Method
    @objc func changeState(_ sender:UISegmentedControl) {
        //1. 사원코드
        let empCd = sender.tag
        //2. 재직상태
        let stateCd = EmpStateType(rawValue: sender.selectedSegmentIndex)
        //3. 재직상태 업데이트
        //업데이트 값이 True일때 알림창이 뜨도록 설정한다.
        if self.empDAO.editState(empCd: empCd, stateCd: stateCd!) {
            let alert = UIAlertController(title: nil, message: "재직 상태가 변경되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // 부서 정보 목록을 구성하는 코드가 들어갑니다.
            let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "부서코드"
                cell?.detailTextLabel?.text = "\(self.departInfo.departCd)"
            case 1:
                cell?.textLabel?.text = "부서명"
                cell?.detailTextLabel?.text = "\(self.departInfo.departTitle)"
            case 2:
                cell?.textLabel?.text = "부서 주소"
                cell?.detailTextLabel?.text = "\(self.departInfo.departAddr)"
            default:
                print("FATAL ERROR")
            }
            return cell!
        } else {
            // 소속 사원 목록을 구성하는 코드가 들어갑니다.
            let row = self.empList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL")
            cell?.textLabel?.text = "\(row.empName) (입사일: \(row.joinDate))"
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
            
            //재직상태를 나타내는 세그먼트 컨트롤
            let state = UISegmentedControl(items: ["재직중", "휴직중", "퇴사"])
            state.frame.origin.x = self.view.frame.width - state.frame.width - 10
            state.frame.origin.y = 10
            state.selectedSegmentIndex = row.stateCd.rawValue // DB에 저장된 상태값으로 설정
            
            //세그먼트 변경에 따른 저장
            state.tag = row.empCd
            state.addTarget(self, action: #selector(changeState), for: .valueChanged)
            
            cell?.contentView.addSubview(state)
            
            return cell!
        }
    }
    
    //헤더 섹션 높이 설정
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //헤더 뷰 설정
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //1. 헤더에 들어각 레이블 객체 정의
        let textHeader = UILabel(frame: CGRect(x: 35, y: 5, width: 200, height: 30))
        textHeader.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 2.5))
        textHeader.textColor = UIColor(red: 0.03, green: 0.28, blue: 0.71, alpha: 1)
        
        //2. 헤더에 들어갈 이미지 뷰 객체 정의
        let icon = UIImageView()
        icon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        
        //3. 섹션에 따라 타이틀과 이미지 다르게 설정
        if section == 0 {
            textHeader.text = "부서 정보"
            icon.image = UIImage(imageLiteralResourceName: "depart")
        } else {
            textHeader.text = "소속 사원"
            icon.image = UIImage(imageLiteralResourceName: "employee")
        }
        //4. 레이블과 이미지 뷰를 담을 컨테이너용 뷰 객체 정의
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        v.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.99, alpha: 1.0)
        
        v.addSubview(textHeader)
        v.addSubview(icon)
        
        return v
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    //각 섹션당 row를 설정함
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 3
        } else {
            return self.empList.count
        }
    }

}
