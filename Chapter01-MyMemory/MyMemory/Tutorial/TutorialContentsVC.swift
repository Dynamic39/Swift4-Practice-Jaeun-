//
//  TutorialContentsVC.swift
//  MyMemory
//
//  Created by Samuel K on 2018. 3. 6..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

//페이지 뷰를 작성할 컨트롤러 생성
class TutorialContentsVC: UIViewController {
    
    //아웃렛 연결
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    
    //맴버 변수 설정
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //전달받은 타이틀 정보를 레이블 객체에 대입
        self.titleLabel.text = self.titleText
        self.titleLabel.sizeToFit()
        
        //전달 받은 이미정보 대입
        self.bgImageView.image = UIImage(named: self.imageFile)
        
    }
}
