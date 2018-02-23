//
//  ProfileVC.swift
//  MyMemory
//
//  Created by Samuel K on 2018. 2. 23..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let profileImage = UIImageView()
    let tv = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn()
        personalAccount()
        backGroundImageMake()
        
        tv.dataSource = self
        tv.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true

        
    }
    
    func backGroundImageMake() {
        let bg = UIImage(named: "profile-bg.png")
        let bgImg = UIImageView(image: bg)
        
        bgImg.frame.size = CGSize(width: bgImg.frame.size.width, height: bgImg.frame.size.height)
        bgImg.center = CGPoint(x: self.view.frame.width / 2, y: 40)
        bgImg.layer.cornerRadius = bgImg.frame.size.width / 2
        bgImg.layer.borderWidth = 0
        bgImg.layer.masksToBounds = true
        
        self.view.addSubview(bgImg)
        
        //순서가 뒤로 될 수 있도록 다른 뷰들을 앞으로 가져온다.
        self.view.bringSubview(toFront: self.tv)
        self.view.bringSubview(toFront: self.profileImage)

    }
    
    func personalAccount() {
        
        //이미지 입력
        let image = UIImage(named: "account.jpg")
        
        self.profileImage.image = image
        self.profileImage.frame.size = CGSize(width: 100, height: 100)
        self.profileImage.center = CGPoint(x: self.view.frame.width/2, y: 270)
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        
        self.view.addSubview(self.profileImage)
        
        //테이블 뷰
        
        tv.frame = CGRect(x: 0, y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20, width: self.view.frame.width, height: 100)
        
        self.view.addSubview(self.tv)
        
    }
    
    func backBtn() {
        let backBtn = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = backBtn
    }
    
    @objc func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "이름"
            cell.detailTextLabel?.text = "Dynamic39"
        case 1:
            cell.textLabel?.text = "계정"
            cell.detailTextLabel?.text = "sky4411v@gmail.com"
        default:
            print("Fatal Error in Switch")
        }
        
        return cell
    }


}
