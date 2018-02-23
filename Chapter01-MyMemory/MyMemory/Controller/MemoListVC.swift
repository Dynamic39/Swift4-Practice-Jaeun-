//
//  MemoListVC.swift
//  MyMemory
//
//  Created by Samuel K on 2017. 10. 30..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class MemoListVC: UITableViewController {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.tableView.reloadData()
        
    }

    // MARK: - Table view data source

    
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
        cell.regdate.text = fommatter.string(from: row.redate!)
        
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
    



}
