//
//  EmployeeDAO.swift
//  Chapter06-HR
//
//  Created by Samuel K on 2018. 3. 8..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit
import FMDB

//열거형 타입으로 간편화 하여 준다.
//FMDB의 State_Cd 칼럼의 경우 Int Type이기 때문에 열거형에 타입 어노테이션을 설정한다.
enum EmpStateType: Int  {
    case ING = 0, STOP, OUT // 순서대로 재직중(0), 휴직(1), 퇴사(2)
    
    func desc() -> String {
        switch self {
        case .ING:
            return "재직중"
        case .STOP:
            return "휴직"
        case .OUT:
            return "퇴사"
        }
    }
}

//Employee VO 구조체를 정의한다.
//구조체로 정의한 이유는 입력
struct EmployeeVO {
    var empCd = 0 // 사원코드
    var empName = "" // 사원명
    var joinDate = "" // 입사일
    var stateCd = EmpStateType.ING // 재직상태(기본값 : 재직중), 저장될때는 정수값으로 변경되는 과정을 거쳐야함
    var deparCd = 0 // 소속부서 코드
    var departTitle = "" // 소속 부서명
}

//FMDB 타입의 객체를생성하고 프로퍼티에 저장합니다.

class EmployeeDAO {
    
    lazy var fmdb: FMDatabase! = {
        
        //1. 파일 매니저 생성
        let fileMgr = FileManager.default
        //2. 샌드박스내 문서 디렉토리 검색
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbpath = docPath!.appendingPathComponent("hr.sqlite").path
        
        //3. 샌드박스에 hr.sqlite 파일이 없을 경우 메인번들에서 가져온다.
        if fileMgr.fileExists(atPath: dbpath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbpath)
        }
        //4. 준비된 데이터베이스 파일을 바탕으로 객체를 생성한다.
        let db = FMDatabase(path: dbpath)
        return db
    }()
    
    //FMDB의 생성자와 소멸자 생성
    init() { self.fmdb.open() }
    deinit { self.fmdb.close() }
    
    //사원목록을 가져올 FIND 메서드
    func find() -> [EmployeeVO] {
        
        var employeeList = [EmployeeVO]()
        
        do {
            let sql = """
SELECT emp_cd, emp_name, join_date, state_cd, department.depart_title
FROM employee
JOIN department ON department.depart_cd = employee.depart_cd
ORDER BY employee.depart_cd ASC
"""
           let rs = try self.fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                var record = EmployeeVO()
                
                //각각의 사원정보를 넣는다.
                record.empCd = Int(rs.int(forColumn: "emp_cd"))
                record.empName = rs.string(forColumn: "emp_name")!
                record.joinDate = rs.string(forColumn: "join_date")!
                record.departTitle = rs.string(forColumn: "depart_title")!
                
                let cd = Int(rs.int(forColumn: "state_cd")) // DB에서 읽어온 state_cd값
                record.stateCd = EmpStateType(rawValue: cd)!
                
                //사원 전체 리스트에 저장하여 준다.
                employeeList.append(record)
            }
        } catch let error {
            print("FIND Error: \(error.localizedDescription)")
        }
        return employeeList
    }
    
    //단일 사원 레코드를 읽어오는 메서드를 설정한다.
    func get(empCd: Int) -> EmployeeVO? {
        
        //1. 질의 실행
        let sql = """
                SLECT emp_cd, emp_name, join_date, state_cd, depatment.depart_tittle
                FROM employee
                JOIN department ON department.depart_cd = employee.depart_cd
                WHERE emp_cd = ?
                """
        
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [empCd])
        
        //2.결과 집합 처리
        if let _rs = rs {
            _rs.next()
            var record = EmployeeVO()
            record.empCd = Int(_rs.int(forColumn: "emp_cd"))
            record.empName = _rs.string(forColumn: "emp_name")!
            record.joinDate = _rs.string(forColumn: "join_date")!
            record.departTitle = _rs.string(forColumn: "depart_title")!
            
            let cd = Int(_rs.int(forColumn: "state_cd"))
            record.stateCd = EmpStateType(rawValue: cd)!
            
            
            return record
        } else {
            print("사원 개인정보를 찾을 수 없습니다.")
            return nil
        }
    }
    
    //신규 사원 정보를 추가할 메서드 정의
    func create(param: EmployeeVO) -> Bool {
        
        do {
            let sql = """
                    INSERT INTO employee (emp_name, join_date, state_cd, depart_cd)
                    VALUES (? , ? , ? , ?)
                    """
        var params = [Any]()
            params.append(param.empName)
            params.append(param.joinDate)
            params.append(param.stateCd.rawValue)
            params.append(param.deparCd)
            
            try self.fmdb.executeUpdate(sql, values: params)
            return true
            
        } catch let error as NSError {
            print("INSERT Error: \(error.localizedDescription)")
            return false
        }
    }
    
    //개별 사원정보를 삭제할 메서드를 구현
    func remove(empCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM employee WHERE emp_cd = ? "
            try self.fmdb.executeUpdate(sql, values: [empCd])
            return true
        } catch let error as NSError {
            print("DELETE ERROR : \(error.localizedDescription)")
            return false
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

