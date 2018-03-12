//
//  MemoDAO.swift
//  MyMemory
//
//  Created by Samuel K on 2018. 3. 12..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit
import CoreData

class MemoDAO {
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    //불러오기
    func fetch(keword text: String? = nil) -> [MemoData] {
        var memolist = [MemoData]()
        
        //1. 요청 객체 생성
        let fetchRequest: NSFetchRequest<MemoMO> = MemoMO.fetchRequest()
        //1-1. 최신 순으로 정렬하도록 정렬 개체 생성
        let regdateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regdateDesc]
        
        //1-2. 검색 키워드가 있을 경우 검색 조건 추가
        if let t = text, t.isEmpty == false {
            fetchRequest.predicate = NSPredicate(format: "contents CONTAINS[c] %@", t)
        }
        
        do {
            let resultset = try self.context.fetch(fetchRequest)
            
            //2. 읽어온 결과 집합을 순회하면서 [MemoData] 타입으로 변환한다.
            for record in resultset {
                //3.MemoData객채를 생성한다.
                let data = MemoData()
                
                data.title = record.title
                data.contents = record.contents
                data.regdate = record.regdate
                data.objectID = record.objectID
                
                //4-1 이미지가 있을 경우 복사
                if let image = record.image as Data? {
                    data.image = UIImage(data: image)
                }
                
                memolist.append(data)
            }
        } catch let e as NSError {
            NSLog("An error has occurred: %s", e.localizedDescription)
        }
        return memolist
    }
    
    //새 메모를 저장하는 메서드 구현
    func insert(_ data:MemoData) {
        //1. 관리 객체 인스턴스 생성
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: self.context) as! MemoMO
        
        //2. Memodata로부터 값을 복한다.
        object.title = data.title
        object.contents = data.contents
        object.regdate = data.regdate!
        
        if let image = data.image {
            object.image = UIImagePNGRepresentation(image)!
        }
        //3. 영구 저장소에 저장한다.
        do {
            try self.context.save()
        } catch let e as NSError {
            NSLog("An error has occurred: %s", e.localizedDescription)
        }
    }
    
    //삭제 메서드 구현
    func delete(_ objectID : NSManagedObjectID) -> Bool {
        
        //삭제할 객체를 찾아 컨텍스트 삭제
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        
        do {
            try self.context.save()
            return true
        } catch let e as NSError {
            NSLog("An error has occurred : %s", e.localizedDescription)
            return false
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

