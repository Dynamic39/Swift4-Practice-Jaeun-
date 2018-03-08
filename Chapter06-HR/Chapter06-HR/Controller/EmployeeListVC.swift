//
//  EmployeeListVC.swift
//  Chapter06-HR
//
//  Created by Samuel K on 2018. 3. 7..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class EmployeeListVC: UITableViewController {

    //데이터 소스 저장할 변수
    var empList:[EmployeeVO]!
    //SQLite 처리를 담당 할 DAO 클래스
    var empDAO = EmployeeDAO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //순서에 유의하여, SQLite에서 Data를 가져온 후, UI를 초기화 하여 준다.
        self.empList = self.empDAO.find()
        self.initUI()

    }
    
    //초기화 함수
    func initUI() {
        
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 14)
        navTitle.text = "사원목록 \n" + " 총 \(self.empList.count) 명"
        self.navigationItem.titleView = navTitle
        
    }
    
    // MARK: - Action Method
    
    
    @IBAction func editing(_ sender: Any) {
        
        if self.isEditing == false {
            self.setEditing(true, animated: true)
            (sender as? UIBarButtonItem)?.title = "Done"
        } else {
            self.setEditing(false, animated: true)
            (sender as? UIBarButtonItem)?.title = "Edit"
            
        }

        
    }
    
    
    
    @IBAction func add(_ sender: Any) {
        
        let alert = UIAlertController(title: "사원 등록", message: "등록할 사원 정보를 입력하여 주세요", preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "사원명" }
        
        //피커뷰 실행
        let pickerVC = DepartPickerVC()
        alert.setValue(pickerVC, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
            //사원 등록 처리 로직
            //1. 알림창의 입력 필드에서 값을 읽어온다.
             var param = EmployeeVO()
            param.deparCd = pickerVC.selectedDepartCd
            param.empName = (alert.textFields?[0].text)!
            
            //2. 가입일을 오늘로 한다.
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            param.joinDate = df.string(from: Date())
            
            //3. 재직상태는 재직으로 한다.
            param.stateCd = EmpStateType.ING
            
            //4. DB처리
            if self.empDAO.create(param: param) {
                self.empList = self.empDAO.find()
                self.tableView.reloadData()
                
                if let navTitle = self.navigationItem.titleView as? UILabel {
                    navTitle.text = "사원목록 \n" + " 총\(self.empList.count) 명"
                }
            }
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.empList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.empList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL")
        
        //사원명, 재직상태 출력
        cell?.textLabel?.text = rowData.empName + " (\(rowData.stateCd.desc()))"
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        cell?.detailTextLabel?.text = rowData.departTitle
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //1. 삭제할 행의 empCd를 구한다.
        let empCd = self.empList[indexPath.row].empCd
        
        //2. DB, DataSource, TableView에서 차레대로 빼준다.
        if empDAO.remove(empCd: empCd) {
            self.empList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

    }

    
    
    
    
    
    
    
    
    
    
    
    
    
}
