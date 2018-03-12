//
//  LogVC.swift
//  Chapter07-CoreData
//
//  Created by Samuel K on 2018. 3. 12..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit
import CoreData

//로그 타입의 정수를 반환하여 로그 값을 주는 열거형을 선언한다.

public enum LogType: Int16 {
    case create = 0, edit, delete
}

//익스텐션 구문을 이용하여 Int16 구조체에 새로운 메서드를 추가한다.
extension Int16 {
    func toLogType() -> String {
        switch self {
        case 0: return "생성"
        case 1: return "수정"
        case 2: return "삭제"
        default: return ""
        }
    }
}

class LogVC : UITableViewController {
    
    //목록 화면에서 전달하는 게시글 객체 저장
    var board: BoardMO!
    
    //로그 리스트를 넣는 곳
    lazy var list: [LogMO]! = {
       return self.board.logs?.array as! [LogMO]
    }()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.board.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "logcell")!
        cell.textLabel?.text = "\(row.regdate!)에 \(row.type.toLogType()) 되었습니다."
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell
    }
    
}
