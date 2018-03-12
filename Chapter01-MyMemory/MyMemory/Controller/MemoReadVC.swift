//
//  MemoReadVC.swift
//  MyMemory
//
//  Created by Samuel K on 2017. 10. 30..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class MemoReadVC: UIViewController {

    var param:MemoData?
    
    @IBOutlet var subject: UILabel!
    @IBOutlet var contents: UILabel!
    @IBOutlet var img: UIImageView!
    
    override func viewDidLoad() {
        self.subject.text = param?.title
        self.contents.text = param?.contents
        self.img.image = param?.image
        
        let fomatter = DateFormatter()
        fomatter.dateFormat = "dd일 HH:ss분에 작성됨"
        let dateString = fomatter.string(from: (param?.regdate)!)
        
        self.navigationItem.title = dateString
        
        
    }
    
    

}
