//
//  ViewController.swift
//  Chapter03-NavigationBar
//
//  Created by Samuel K on 2017. 11. 13..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initTitleNew()
        // initTitleImage()
        initTitleInput()
    }
    
    
    func initTitleInput()
    {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 300, height: 35)
        tf.backgroundColor = UIColor.white
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.keyboardType = .URL
        tf.keyboardAppearance = .dark
        
        tf.layer.borderWidth = 0.3
        tf.layer.borderColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0).cgColor
        
        self.navigationItem.titleView = tf
        
//        let v = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 37))
//        v.backgroundColor = UIColor.brown
//
//        let leftItem = UIBarButtonItem(customView: v)
//        self.navigationItem.leftBarButtonItem = leftItem
        
        
        let rv = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 37))
        let rightItem = UIBarButtonItem(customView: rv)
        self.navigationItem.rightBarButtonItem = rightItem
        
        let cnt = UILabel()
        cnt.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
        cnt.font = UIFont.boldSystemFont(ofSize: 10)
        cnt.textColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        cnt.text = "12"
        cnt.textAlignment = .center
        cnt.layer.cornerRadius = 3
        cnt.layer.borderWidth = 2
        cnt.layer.borderColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        rv.addSubview(cnt)
        
        let more = UIButton()
        more.frame = CGRect(x: 50, y: 10, width: 16, height: 16)
        more.setImage(UIImage(named: "more"), for: .normal)
        
        rv.addSubview(more)
        
        let back = UIImage(named: "arrow-back")
        let leftItem = UIBarButtonItem(image: back, style: .plain, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem = leftItem
        
        
        
        
    }
    
    
    func initTitleImage(){
        let image = UIImage(named: "swift_logo")
        let imageV = UIImageView(image: image)
        
        self.navigationItem.titleView = imageV
    }
    
    
    
    //네비게이션 타이틀을 2열로 하는 구조, 이는 NavigationBar가 UIView를 상속받고 있기 때문에 가능하다.
    func initTitleNew() {
        
        //각각 줄별로 별도로 관리 할 수 있는 구조로 바꿔준다.
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        
        //프로퍼티 설정
        let topTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 18))
        topTitle.numberOfLines = 1
        topTitle.textAlignment = .center
        topTitle.font = UIFont.systemFont(ofSize: 15)
        topTitle.text = "58개 숙소"
        
        let subTitle = UILabel(frame: CGRect(x: 0, y: 18, width: 200, height: 18))
        subTitle.numberOfLines = 1
        subTitle.textAlignment = .center
        subTitle.font = UIFont.systemFont(ofSize: 10)
        subTitle.text = "1박(1월10일 ~ 1월11일)"
        
        //네비게이션 타이틀에 입력
        
        containerView.addSubview(topTitle)
        containerView.addSubview(subTitle)
        self.navigationItem.titleView = containerView
        
        //프로퍼티의 색상 설정
        
        let color = UIColor(displayP3Red: 0.02, green: 0.22, blue: 0.49, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = color
        
    }
    
    
}

