//
//  ListVC.swift
//  Chapter07-CoreData
//
//  Created by Samuel K on 2018. 3. 9..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit
import CoreData

class ListVC: UITableViewController {
    
    lazy var list: [NSManagedObject] = {
       return self.fetch()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAddBtn()
        
        
    }
    
    //MARK: - UI handle Method
    
    @objc func add(_ sender:Any) {
        
        //입력 필드 추가
        let alert = UIAlertController(title: "게시글 등록", message: nil, preferredStyle: .alert)
        alert.addTextField() {$0.placeholder = "제목"}
        alert.addTextField() {$0.placeholder = "내용"}
        
        //버튼추가(Cancel / Save)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
                guard let title = alert.textFields?.first?.text,
                    let contents = alert.textFields?.last?.text else { return }
                
                if self.save(title: title, contents: contents) == true {
                    self.tableView.reloadData()
                }
            }))
        self.present(alert, animated: false, completion: nil)
        
        
        
    }
    
    func createAddBtn() {
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        self.navigationItem.rightBarButtonItem = addBtn
    }
    
    
    
    //MARK: - CoreData Handle Method
    
    //수정하기
    //삭제기능의 플로우와 비슷하다.
    func edit(object: NSManagedObject, title:String, contents:String) -> Bool {
        //1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext
        //3. 관리 객체의 값을 수정
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")
        
        //3-1 Log관리 객체 생성 및 어트리뷰트에 값 대입
        let logObject = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        logObject.regdate = Date()
        logObject.type = LogType.edit.rawValue
        
        (object as! BoardMO).addToLogs(logObject)
        
        //영구 저장소에 반영
        do {
            try context.save()
            self.list = self.fetch()
            return true
        } catch  {
            context.rollback()
            return false
        }
    }
    
    //삭제
    //삭제시 데이터가 컨텍스트에 없는 경우 불러와야한다.
    //삭제의 행위 자체가 데이터를 없는 것으로 덮어 쓰는것과 비슷하다.
    func delete(object: NSManagedObject) -> Bool {
        //1.앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext
        //3. 컨텍스트로부터 해당 객체 삭제
        context.delete(object)
        
        //4. 영구 저장소에 커밋하여 준다.
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    
    //저장
    func save(title: String, contents:String) -> Bool {
        //1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //2. 관리 객체 컨첵스트 참조
        let context = appDelegate.persistentContainer.viewContext
        //3. 관리 객체 생성 및 값 설정
        let object = NSEntityDescription.insertNewObject(forEntityName: "Board", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")
        
        //3-1. Log관리 객체 생성 및 어트리뷰트에 값 대입
        let logObject = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        logObject.regdate = Date()
        logObject.type = LogType.create.rawValue // 열거형을 사용한다.
        //3-2. 게시글 객체의 logs 속성에 새로 생성된 로그 객체 추가
        (object as! BoardMO).addToLogs(logObject)
        
        //4. 영구 저장소에 커밋되고 나면, list프로퍼티에 추가한다.
        //5. 새 게시글 등록시, list의 0번 인덱스에 저장되도록 한다.
        do {
            try context.save()
            //self.list.append(object)
            self.list.insert(object, at: 0)
            return true
        } catch {
            context.rollback()
            print("FATAL ERROR FOR CORE DATA SAVING")
            return false
        }
        
    }
    
    //불러오기
    func fetch() -> [NSManagedObject] {
        //1. 앱 딜리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //2. 관리 객체 컨첵스트 참조
        let context = appDelegate.persistentContainer.viewContext
        //3. 요청 객체 생성
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board")
        //등록 날짜 기준으로 내림차순 결정하기
        //정렬 속성 설정
        let sort = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        //4. 데이터 가져오기
        let result = try! context.fetch(fetchRequest)
        
        
        
        return result
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    //액세서리가 선택되었을때 구현하는 화면
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let object = self.list[indexPath.row]
        let uvc = self.storyboard?.instantiateViewController(withIdentifier: "LogVC") as! LogVC
        
        uvc.board = object as! BoardMO
        self.show(uvc, sender: self)
    }
    
    //셀을 선택하였을 때, 수정가능하게 한다.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //1. 데이터 불러오기
        let object = self.list[indexPath.row]
        let title = object.value(forKey: "title") as? String
        let contents = object.value(forKey: "contents") as? String
        
        let alert = UIAlertController(title: "게시글 수정", message: nil, preferredStyle: .alert)
        
        //2. 입력 필드 추가(기본 값을 입력)
        alert.addTextField() {$0.text = title}
        alert.addTextField() {$0.text = contents}
        
        //3. 버튼 추가
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "SAVE", style: .default, handler: { (_) in
            guard let title = alert.textFields?.first?.text,
                let contents = alert.textFields?.last?.text else { return }
            
            if self.edit(object: object, title: title, contents: contents) {
                //self.tableView.reloadData()
                //셀의 내용을 직접 수정한다.
                let cell = self.tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = title
                cell?.detailTextLabel?.text = contents
                
                //수정된 셀을 첫번째 행으로 이동시킨다.
                let firstIndexPath = IndexPath(item: 0, section: 0)
                self.tableView.moveRow(at: indexPath, to: firstIndexPath)
            }
        }))
        
        self.present(alert, animated: false, completion: nil)
        
    }
    
    //delete 가능하게 만듬
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    //실제로 삭제 코드를 구현하는 메서드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let object = self.list[indexPath.row] // 삭제될 행
        
        //Core Data의 삭제 메서드를 구현한다.
        if self.delete(object: object) {
            self.list.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //data 로딩.
        let record = self.list[indexPath.row]
        let title = record.value(forKey: "title") as? String
        let contents = record.value(forKey: "contents") as? String
        
        //셀을 생성하고 배치한다.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = contents
        
        return cell
        
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //테이블 뷰의 목록 개수 지정
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.list.count
    }

}
