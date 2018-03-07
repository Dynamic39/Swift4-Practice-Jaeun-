//
//  DepartmentDAO.swift
//  Chapter06-HR
//
//  Created by Samuel K on 2018. 3. 7..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit
import FMDB // 임포트


//DAO 설정하여, 객체를 원활하게 제어한다.

//DAO 설정 클래스
class DepartmentDAO {
    
    //튜플 타입인 타입 얼라이어스 설정
    //부서 코드 / 부서명 / 부서 주소를 가지고 온다.
    typealias DepartRecord = (Int, String, String)
    
    //클로져 구문을 활용한 초기화
    lazy var fmdb: FMDatabase! = {
        //1. 파일매니저 객체 생성
        let fileMgr = FileManager.default
        //2. 샌드박스내 문서 디렉토리에서 데이터베이스 파일 경로 확인
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendingPathComponent("hr.sqlite").path
        //3. 샌드박스내 경로가 없다면 메인번들 데이터를 저장하여 준다.
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        //준비된 데이터베이스 파일을 바탕으로 FMDB를 작성
        let db = FMDatabase(path: dbPath)
        return db
    }()
    
    //생성자 / 소멸자 생성
    init() { self.fmdb.open() }
    deinit { self.fmdb.close() }
    
    //테이블로 부터 부서목록을 읽어올 메서드 정의
    func find() -> [DepartRecord] {
        //변수 선언
        var departList = [DepartRecord]()
        
        do {
            //1. 부서 정보 목록을 가져올 SQL 생성
            let sql = """
                    SELECT depart_cd, depart_title, depart_addr
                    FROM department
                    ORDER BY depart_cd ASC
                """
            let rs = try self.fmdb.executeQuery(sql, values: nil)
            
            //2. 결과 집합 추출
            while rs.next() {
                let departCd = rs.int(forColumn: "depart_cd")
                let departTitle = rs.string(forColumn: "depart_title")
                let departArrd = rs.string(forColumn: "depart_addr")
                //튜플 사용시 괄호를 꼭 써준다.
                departList.append((Int(departCd), departTitle!, departArrd!))
            }
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            //결과 집합 추출
            return departList
        }
}

