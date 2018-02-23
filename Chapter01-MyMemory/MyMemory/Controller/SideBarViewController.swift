//
//  SideBarViewController.swift
//  MyMemory
//
//  Created by Samuel K on 2018. 2. 23..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class SideBarViewController: UITableViewController {
    
    //테이블 뷰 목록 데이터 배열
    let titles = ["새글 작성하기", "친구 새글", "달력으로 보기", "공지사항", "통계", "계정 관리"]
    let icons = [
        UIImage(named: "icon01.png"),
        UIImage(named: "icon02.png"),
        UIImage(named: "icon03.png"),
        UIImage(named: "icon04.png"),
        UIImage(named: "icon05.png"),
        UIImage(named: "icon06.png")
    ]
    
    //기본정보 추가하기
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let profileImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addHeaderView()
        
    }
    
    //헤더 추가하기
    func addHeaderView() {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        headerView.backgroundColor = .brown
        self.tableView.tableHeaderView = headerView
        
        //기본 정보 추가하기
        self.nameLabel.frame = CGRect(x: 70, y: 15, width: (headerView.frame.width/3) * 2, height: 30)
        self.nameLabel.textAlignment = .left
        self.nameLabel.text = "Dynamic39"
        self.nameLabel.textColor = .white
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.nameLabel.backgroundColor = .clear
        
        headerView.addSubview(self.nameLabel)
        
        self.emailLabel.frame = CGRect(x: 70, y: 30, width: (headerView.frame.width/3) * 2, height: 30)
        self.emailLabel.textAlignment = .left
        self.emailLabel.text = "sky4411v@gmail.com"
        self.emailLabel.font = UIFont.systemFont(ofSize: 11)
        self.emailLabel.backgroundColor = .clear
        
        headerView.addSubview(self.emailLabel)
        
        let defaultProfile = UIImage(named: "account.jpg")
        self.profileImage.image = defaultProfile
        self.profileImage.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        
        //프로필 이미지 둥글게 만들기
        
        self.profileImage.layer.cornerRadius = (self.profileImage.frame.width / 2)
        self.profileImage.layer.borderWidth = 0 // 테두리 두께 0
        self.profileImage.layer.masksToBounds = true // 마스크 효과
        
    
        view.addSubview(self.profileImage) // 헤더뷰에 추가
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let id = "menucell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { // 새글 작성일때
            
            //해당 스토리보드 아이디를 가진 뷰컨트롤러를 불러온다.
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "MemoForm")
            //타겟 설정을 한다. 현재 revealViewController 와 메인 frontViewController 이 연결되었기 때문에, 네비게이션 컨트롤러로 연결하여 준다.
            let target = self.revealViewController().frontViewController as! UINavigationController
            //해당 타겟이 uv 를 따라갈 수 있도록 푸시를 해준다.
            target.pushViewController(uv!, animated: true)
            //사이드 바를 닫아준다.
            self.revealViewController().revealToggle(self)
            
        } else if indexPath.row == 5 { // 계정 관리
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "_profile")
            self.present(uv!, animated: true, completion: {
                self.revealViewController().revealToggle(self)
            })
            
        }
        
        
        
        
        
        
        
        
        
        
        
    }

}
