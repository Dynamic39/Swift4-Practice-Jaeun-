//
//  ViewController.swift
//  Chapter06-SQLite3
//
//  Created by Samuel K on 2018. 3. 7..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbPath = self.getDBPath()
        self.dbExcute(dbPath: dbPath)
        
    }
    
    //SQL 구문 실행
    func dbExcute(dbPath: String) {
        //SQLite3 사용
        var db: OpaquePointer? = nil // SQLite 연결정보 저장 객체
        var stmt: OpaquePointer? = nil // 컴파일된 SQL을 담을 객체
        
        //SQL Table 작성
        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)" // IF NOT EXISTS 를 작성해 줌으로써 중복되서 시퀀스가 생성되지 않도록 조치한다.
        
        //함수 5단계를 불러내서 실행함
        // 1. 함수를 호출하여 DB연결
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            print("DataBase Connect Fail!!")
            return }
        
        // SQL 구문 전달 준비, 컴파일된 SQL 구문객체 생성(=stmt)
        guard sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            print("Prepate Statment Fail!!")
            return }
        
        //DB 연결 종료는 Defer를 사용하여 진행한다.
        defer {
            //DB연결 종료, db 객체가 해제됨
            sqlite3_close(db)
        }
        
        // 컴파일된 SQL 구문 객체를 DB에 전달함
        if sqlite3_step(stmt) == SQLITE_DONE { print("Create Table Success") }
        
        //stmt 연결 종료는 Defer를 사용하여 진행한다.
        defer {
            // SQL 구문 삭제 이과정에서 stmt해제
            sqlite3_finalize(stmt)
            print("SQL DATA ALL CLOSE!")
        }
    }
    
    //PATH 를 구하기 위해 새로운 메서드 작성
    func getDBPath() -> String {
        
        //앱 내 디렉터리 경로에서 SQLite DB파일을 찾는다
        let fileMgr = FileManager() // 파일 매니저 경로 생성
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first! // 앱내 문서 디렉터리 경로 검색 및 URL객체 생성
        let dbPath = try! docPathURL.appendingPathComponent("db.sqlite").path // URL객체내에 db.sqlite 파일 경로를 추가한 SQLite 경로 생성
        
        //dbPath에 경로가 없을 경우 앱 번들에서 가져와 복사한다.
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        return dbPath
    }

}

