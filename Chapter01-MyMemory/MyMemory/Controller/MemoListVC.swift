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
