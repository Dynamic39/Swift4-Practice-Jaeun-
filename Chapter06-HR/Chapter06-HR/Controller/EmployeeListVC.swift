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
    
    //리프레시 컨트롤을 커스텀으로 수정함
    var loadingImg: UIImageView!
    var bigCircle: UIView! // 다돌고 나서 마지막에 나타는 원
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //순서에 유의하여, SQLite에서 Data를 가져온 후, UI를 초기화 하여 준다.
        self.empList = self.empDAO.find()
        self.initUI()
        refreshControl()
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
    
    // MARK: - Handle Method
    
    //리프레시 컨트롤을 추가함
    func refreshControl() {
        
        self.refreshControl = UIRefreshControl()
        
        self.bigCircle = UIView()
        bigCircle.backgroundColor = UIColor.yellow
        bigCircle.center.x = (self.refreshControl?.frame.width)! / 2
        
        self.loadingImg = UIImageView(image: UIImage(named: "refresh"))
        self.loadingImg.center.x = (self.refreshControl?.frame.width)!/2
        
        //self.refreshControl?.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        
        self.refreshControl?.tintColor = UIColor.clear // 틴트 값을 제거하면 인디케이터가 나타나지 않으므로, 클리어 처리를 해준다.
        self.refreshControl?.addSubview(self.loadingImg)
        self.refreshControl?.addSubview(self.bigCircle)
        self.refreshControl?.bringSubview(toFront: self.loadingImg) // 해당 뷰를 가장 상단으로 올려준다.
        self.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
    
    
    // MARK: - Action Method
    
    //리프레시 컨트롤이 실행되면 작동하는 액션 메서드
    @objc func pullToRefresh(_ sender:Any) {
        
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)
        //5. 노란 원이 로딩이미지를 중심으로 커지는 애니매이션 구현
        UIView.animate(withDuration: 0.5) {
            self.bigCircle.frame.size.width = 80
            self.bigCircle.frame.size.height = 80
            self.bigCircle.center.x = (self.refreshControl?.frame.width)! / 2
            self.bigCircle.center.y = distance / 2
            self.bigCircle.layer.cornerRadius = (self.bigCircle.frame.size.width) / 2
        }
        
        self.empList = self.empDAO.find()
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
        

        
    }
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
    // MARK: - ScrollView Data Source
    
    //스크롤 시작
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //스크롤이 발생할 때마다 처리할 내용을 담는다.
        //refresh 객체의 좌표값을 이용하여, 스크롤에 의해 당겨진 거리를 계산한다.
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)
        
        //center.y 좌표를 당긴 거리만큼 수정
        self.loadingImg.center.y = distance / 2
        //당긴 거리만큼 그림이 돌아가게 한다.
        let ts = CGAffineTransform(rotationAngle: CGFloat(distance/20))
        self.loadingImg.transform = ts
        
        //배경뷰의 중심좌표 설정
        self.bigCircle.center.y = distance / 2
        
    }
    
    //스크롤 종료
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.bigCircle.frame.size.width = 0
        self.bigCircle.frame.size.height = 0
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
