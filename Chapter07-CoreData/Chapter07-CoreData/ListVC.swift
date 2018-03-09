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
        
        //4. 영구 저장소에 커밋되고 나면, list프로퍼티에 추가한다.
        do {
            try context.save()
            self.list.append(object)
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
        //4. 데이터 가져오기
        let result = try! context.fetch(fetchRequest)
        
        return result
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
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
