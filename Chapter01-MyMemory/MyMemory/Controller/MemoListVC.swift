//
//  MemoListVC.swift
//  MyMemory
//
//  Created by Samuel K on 2017. 10. 30..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class MemoListVC: UITableViewController, UISearchBarDelegate {

    lazy var dao = MemoDAO() // 1. CoreData연결
    @IBOutlet weak var searchBar: UISearchBar!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //전체검색?
        searchBar.enablesReturnKeyAutomatically = false
        
        makeVCForSidebarButton()

    }
    
    func makeVCForSidebarButton() {
        //SWRevealViewController 객체를 읽어 온다.
        if let revealVC = self.revealViewController() {
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu.png")
            btn.target = revealVC
            btn.action = #selector(revealVC.revealToggle(_:)) // 버튼 클릭시 토글 호출
            
            self.navigationItem.leftBarButtonItem = btn // 버튼 객체에 넣어줌
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.appDelegate.memoList = self.dao.fetch() // 저장된 코어 데이터 가지고 오기
        
        self.tableView.reloadData()
        
        let ud = UserDefaults.standard
        if ud.bool(forKey: UserInfoKey.tutorial) == false {
            let vc = self.instanceTutorialVC(name: "MasterVC")
            self.present(vc!, animated: false)
            
            return
        }
        
    }

    // MARK: - Table view data source
    
    //삭제 딜리게이트 메서드 구현
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.appDelegate.memoList[indexPath.row]
        
        if dao.delete(data.objectID!) {
            self.appDelegate.memoList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //삭제모드 실행
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        let count = self.appDelegate.memoList.count

        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let row = self.appDelegate.memoList[indexPath.row]
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        
        cell.subject?.text = row.title
        cell.contents?.text = row.contents
        cell.img?.image = row.image
        
        let fommatter = DateFormatter()
        fommatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate.text = fommatter.string(from: row.regdate!)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = self.appDelegate.memoList[indexPath.row]
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadVC else {
            return
        }
        
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    //MARK: - SearchBar Methods
    
    //서치 버튼이 클릭되었을때 실행하는 메서드
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let keyword = searchBar.text
        self.appDelegate.memoList = self.dao.fetch(keword: keyword)
        self.tableView.reloadData()
        
    }
    



}
