//
//  CSLogButton.swift
//  MyMemory
//
//  Created by Samuel K on 2018. 2. 22..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

//enum타입을 정의 하여, 로깅타입을 정의할 객채를 추가한다.
public enum CSLogType: Int {
    case basic
    case title
    case tag
}

public class CSLogButton: UIButton {
    
    //로그 타입 프로퍼티 추가, 기본값은 베이직
    public var logType: CSLogType = .basic
    
    //스토리 보드 타입 방식의 버튼 인스턴스 생성
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //버튼의 스타일 적용
        self.setBackgroundImage(UIImage(named: "button-bg"), for: .normal)
        self.tintColor = UIColor.white
        
        //버튼 이벤트에 logging method를 연결
        self.addTarget(self, action: #selector(logging(_:)), for: .touchUpInside)
    }
    
    @objc func logging(_ sender: UIButton) {
        switch self.logType {
        case .basic:// 단순히 로그만 출력
            NSLog("버튼이 클릭되었습니다")
        case .title: // 로그에 버튼의 타이틀을 출력함
            let btnTitle = sender.titleLabel?.text ?? "타이틀 없는" // 옵셔널 타입의 nil값 대응
            NSLog("\(btnTitle) 버튼이 클릭되었습니다")
        case .tag: //로그에 버튼의 태그를 출력함
            NSLog("\(sender.tag) 태그 버튼이 클릭되었습니다.")
        }
    }
    
    
}

