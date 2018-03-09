//
//  DepartmentListVC.swift
//  Chapter06-HR
//
//  Created by Samuel K on 2018. 3. 7..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class DepartmentListVC: UITableViewController {
    
    //데이터 소스용 맴버 변수
    var departList: [(departCd: Int, departTitle:String, departAddr:String)]!
    //SQlite 처리를 담당할 DAO 객체
    let departDAO = DepartmentDAO()

    override func viewDidLoad() {
        super.viewDidLoad()
        //기존에 저장된 부서 정보를 가져옴
        self.departList = self.departDAO.find()
        self.initUI()
        
    }
    
    //UI초기화 함수
    func initUI() {
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 14)
        navTitle.text = "부서목록 \n" + " 총 \(self.departList.count) 개"
        
        self.navigationItem.titleView = navTitle // navTitle을 Navigation Controller Title 뷰에 대치
        self.navigationItem.leftBarButtonItem = self.editButtonItem // 편집버튼 추가
        
        //셀을 스와이프 했을 떄 편집모드로 실행
        self.tableView.allowsSelectionDuringEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Method
    
    @IBAction func add(_ sender: Any) {
        //비지니스 로직 삽입
        
        let alert = UIAlertController(title: "신규 부서 등록", message: "신규 부서를 등록하여 주세요", preferredStyle: .alert)
        
        alert.addTextField { (tf) in tf.placeholder = "부서명" }
        alert.addTextField { (tf) in tf.placeholder = "주소" }
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            //확인 후 실행버튼
            
            let title = alert.textFields?[0].text // 부서명
            let addr = alert.textFields?[1].text // 부서주소
            
            //데이터 베이스에서 신규 부서를 만들어준다.
            if self.departDAO.create(title: title!, addr: addr!) {
                self.departList = self.departDAO.find()
                self.tableView.reloadData()
                
                let navTitle = self.navigationItem.titleView as! UILabel
                navTitle.text = "부서목록 \n" + " 총 \(self.departList.count) 개"
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //화면이동시 전달될 코드
        let departCd = self.departList[indexPath.row].departCd
        //이동할 대상 뷰 컨트롤러의 인스턴스
        let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "DEPART_INFO")
        if let _infoVC = infoVC as? DepartmentInfoVC {
            _infoVC.departCd = departCd
            self.navigationController?.pushViewController(_infoVC, animated: true)
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.departList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.departList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
        
        cell?.textLabel?.text = rowData.departTitle
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.detailTextLabel?.text = rowData.departAddr
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell!
    }
    
    //데이터 삭제 구현
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //1. 삭제할 행의 departCd를 구한다.
        let departCd = self.departList[indexPath.row].departCd
        
        //2. DB, DataSource, TableView에서 차례로 삭제한다.
        if departDAO.remove(departCd: departCd) {
            self.departList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

