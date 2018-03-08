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
                print("FIND PROCESS SUCSSESS")
            }
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            //결과 집합 추출
            return departList
        }
    
    //단일부서 정보 로드 메서드 정의
    func get(departCd: Int) -> DepartRecord? {
        //1. 질의 실행
        let sql = """
                SELECT depart_cd, depart_title, depart_addr
                FROM department
                WHERE depart_cd = ?
                """
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [departCd])
        
        //결과 집합처리
        //옵셔널 타입을 반환하므오 바인딩하여 해제
        if let _rs = rs {
            _rs.next()
            
            let departId = _rs.int(forColumn: "depart_cd")
            let departTitle = _rs.string(forColumn: "depart_title")
            let departAddr = _rs.string(forColumn: "depart_addr")
            
            print("GET PROCESS SUCSSESS")
            return (Int(departId), departTitle!, departAddr!)
            
        } else { // 결과값이 없을 경우 nil반환
            return nil
        }
    }
    
    // 부서정보 추가 메서드
    func create(title: String!, addr: String!) -> Bool {
        do {
            let sql = """
                    INSERT INTO department (depart_title, depart_addr)
                    VALUES (?, ?)
                    """
            try self.fmdb.executeUpdate(sql, values: [title, addr])
            print("INSERT PROCESS SUCSSESS")
            return true
        } catch let error as NSError {
            print("INSERT Error: \(error.localizedDescription)")
            return false
        }
    }
    
    //부서정보 삭제 메서드
    func remove(departCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM department WHERE depart_cd = ? "
            try self.fmdb.executeUpdate(sql, values: [departCd])
            print("DELETE PROCESS SUCSSESS")
            
            return true
            
        } catch let error as NSError {
            print("DELETE Error : \(error.localizedDescription)")
            
            return false
        }
    }
}

