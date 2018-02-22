//
//  SamCalender.swift
//  (1108)CustomCalender
//
//  Created by Samuel K on 2017. 11. 8..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

//프로토콜을 만듬

@objc protocol SamCalenderDelegate {
    
    @objc optional func calendar(_ calendar:SamCalender, didSeletedDate:Date)
    
}

class SamCalender: UIView {
    
    var year:Int?
    var month:Int?
   
    

    // MARK: - Property
    //달력에 대한 기본정보를 습득한다.
    var date:Date?{
        willSet{
            calendarData = SamCalendarDataModel(date: newValue!)
            year = calendarData?.year
            month = calendarData?.month
            contentsView.reloadData()
            
        }
    }
    
    private var calendarData:SamCalendarDataModel?
    
    //외부 접근 불가한, 컬렉션 뷰를 생성한다.
    
    
    //MARK: - Private Property
    private var contentsView:UICollectionView = {
        //컬렉션 뷰를 만들땐 레이아아웃이 꼭 초기화 되어야 한다.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
        
        return collection
    }()
    
    private let cellIdentifier = "Cell"
    
    //MARK: - init
    override func awakeFromNib() {
        
        setupUI()
        updateLayout()
        contentsView.backgroundColor = .white
        
    }
    
    //초기화 구문을 실행한다.
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //날짜 전환을 위한 메서드를 구현
    
    func updateNextMonth(){
        
        date = SamCalenderManager.nextMonth(with: calendarData!)
        
    }
    
    func updatePreMonth(){
        
        date = SamCalenderManager.preMonth(with: calendarData!)
        
        
    }
    
    //UI관련 셋업이 필요한 경우
    
    private func setupUI() {
        self.addSubview(contentsView)
        contentsView.delegate = self
        contentsView.dataSource = self
        contentsView.register(CustomCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    //오토레이아웃을 코드로써 작성함
    private func updateLayout(){
        
        //프레임베이스 기능 사용의 값을 꺼준다
        
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        
        //커스텀 뷰 안에 있는 컬렉션 뷰의 세부 링크를 잡아준다.
//        contentsView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        contentsView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        contentsView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        contentsView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //메서드를 추가로 생성하여, 적용 할 수도 있다
        contentsView.constraint(targetView: self, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
        
 
//        contentsView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        
        
    }
}

extension SamCalender:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    

    // 플로우 레이아웃에 들어가 있는 아이템임
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = contentsView.frame.size.width / 7
        
        if indexPath.section == 0 {
            return CGSize(width: width, height: 30)
        }else{
            return CGSize(width: width, height: width)
        }
        
        
    }
    
    //셀 선택에 대한 레이블을 만듬
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let cell = collectionView.cellForItem(at: indexPath)
//
//        cell?.contentView.layer.backgroundColor = .white
//
//
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 7
        }else{
            
            if let calendarData = calendarData{
                return calendarData.lastDayOfMonth + calendarData.startWeekOfMonth.rawValue
            }else{
                return 0
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCell
        
        //if문을 통하여 섹션을 나눔
        cell.titleLB.text = ""
        
        if indexPath.section == 0 {
           cell.titleLB.text = weekDay(rawValue: indexPath.item)?.name
            
        }else{
            let changeIndex = indexPath.item - calendarData!.startWeekOfMonth.rawValue
            if changeIndex >= 0 {
                let day = changeIndex + 1
                cell.titleLB.text = "\(day)"
            }
        }
        
        return cell
    }
    
    
}

class CustomCell: UICollectionViewCell {
    
    var titleLB : UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        
        return lb
        
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //순서상, 레이블을 먼저 세팅하고, 그다음에 레이아웃을 세팅하여야 한다.
        setupUI()
        updateLayout()

    }
    
    private func setupUI() {
        self.addSubview(titleLB)
        
    }
    
    private func updateLayout(){
        
        //프레임베이스 기능 사용의 값을 꺼준다
        
        titleLB.translatesAutoresizingMaskIntoConstraints = false
        
        //커스텀 뷰 안에 있는 컬렉션 뷰의 세부 링크를 잡아준다.
//        titleLB.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        titleLB.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        titleLB.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        titleLB.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //메소드를 추가로 생성하여, 만들어 줄수도 있다
        titleLB.constraint(targetView: self, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
        
        
//        titleLB.centerXAnchor.constraint(equalTo: self.centerXAnchor)
//        titleLB.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        
        //        contentsView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension UIView {
    
    func constraint(targetView:UIView, topConstant:CGFloat?, bottomConstant:CGFloat?, leftConstant:CGFloat?, rightConstant:CGFloat?) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let constant = topConstant {
            self.topAnchor.constraint(equalTo: targetView.topAnchor, constant: constant).isActive = true
        }
        if let constant = bottomConstant {
            self.bottomAnchor.constraint(equalTo: targetView.bottomAnchor, constant: constant).isActive = true
        }
        if let constant = leftConstant {
            self.leftAnchor.constraint(equalTo: targetView.leftAnchor, constant: constant).isActive = true
        }
        if let constant = rightConstant {
            self.rightAnchor.constraint(equalTo: targetView.rightAnchor, constant: constant).isActive = true
        }
        
    }
    
}


















