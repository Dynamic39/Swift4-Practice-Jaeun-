//
//  ViewController.swift
//  (1108)CustomCalender
//
//  Created by Samuel K on 2017. 11. 8..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var samCalender: SamCalender!
    @IBOutlet var selectedMonth: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        samCalender.date = Date()
        
        selectedMonth.text = "\(samCalender.month!)월"
        
    }
        
    func calendar(_ calendar:SamCalender, didSelectedData:Date){
        
        
    
    }
    
    
    @IBAction func nextMonthHandler(_ sender: UIButton) {
     
        samCalender.updateNextMonth()
        selectedMonth.text = "\(samCalender.month!)월"
        //selectedMonth.text = "\(samCalender.year!)년"
        
    }
    
    
    @IBAction func previousMonthHandler(_ sender: UIButton) {
        samCalender.updatePreMonth()
        selectedMonth.text = "\(samCalender.month!)월"
    }
    
    
}

