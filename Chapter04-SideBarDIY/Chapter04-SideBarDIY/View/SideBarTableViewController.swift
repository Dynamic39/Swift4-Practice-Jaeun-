//
//  SideBarTableViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by Samuel K on 2018. 2. 22..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class SideBarTableViewController: UITableViewController {
    
    //메뉴를 설정함
    let titles = [
        "메뉴01",
        "메뉴02",
        "메뉴03",
        "메뉴04",
        "메뉴05",
    ]
    
    //매뉴 아이콘 배열
    let icons = [
        UIImage(named: "icon01.png"),
        UIImage(named: "icon02.png"),
        UIImage(named: "icon03.png"),
        UIImage(named: "icon04.png"),
        UIImage(named: "icon05.png"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. 계정 정보를 표시한다.
        let accountLabel = UILabel()
        accountLabel.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 30)
        accountLabel.text = "sky4411v@gmail.com"
        accountLabel.textColor = UIColor.white
        accountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        //2. 테이블뷰 상단에 표시될 뷰를 설정한다.
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70)
        v.backgroundColor = .brown
        v.addSubview(accountLabel)
        
        //3. 생성한 뷰를 헤더 뷰 영역에 등록한다.
        self.tableView.tableHeaderView = v
        
    }

    //테이블 뷰의 row수를 정함
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.titles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 1. 재사용 큐로부터 테이블 셀을 꺼내온다.
        let id = "menucell" // 재사용 큐 식별자
        //옵셔널 연산자를 사용하여 간결화 시킨다.
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        
//        // 2. 재사용 큐의 등록된 테이블 뷰 셀이 없다면 새롭게 추가
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: id)
//        }
        
        //3. 셀 구성 요소 생성
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
    

        return cell
    }
 

}
