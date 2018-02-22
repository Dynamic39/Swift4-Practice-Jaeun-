//
//  CSStepper.swift
//  Chapter03-CSStepper
//
//  Created by Samuel K on 2017. 11. 28..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit
@IBDesignable


class CSStepper: UIControl {

    @IBInspectable
    public var leftTitle:String = "▼" {
        didSet{
            self.leftBtn.setTitle(leftTitle, for: .normal)
        }
    }
    @IBInspectable
    public var rightTitle:String = "▲" {
        didSet {
            self.rightBtn.setTitle(rightTitle, for: .normal)
        }
    }
    @IBInspectable
    public var bgColor: UIColor = UIColor.cyan {
        didSet {
            self.centerLabel.backgroundColor = backgroundColor
        }
    }
    
    // 증감값 단위를 설정하여 준다.
    @IBInspectable
    public var stepValue: Int = 1
    
    //버튼들을 정의한다.
    
    public var leftBtn = UIButton(type: .system)
    public var rightBtn = UIButton(type: .system)
    public var centerLabel = UILabel()
    public var value: Int = 0 {
        didSet {
            self.centerLabel.text = String(value)
            //해당 클래스의 객체들에게 값이 바뀌는 이벤트 신호를 보낸다.
            self.sendActions(for: .valueChanged)
        }
    } // 스태퍼의 현재 값을 저장할 변수
    
    //최대값과 최소값을 설정
    @IBInspectable
    public var maximumValue: Int = 100
    
    @IBInspectable
    public var minimumValue: Int = -100
    
    //스토리보드에서 호출할 초기화 메소드
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
        
    }
    
    //프로그래밍 방식으로 호출할 메소드
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        
    }
    
    private func setup(){
        
        let borderWidth: CGFloat = 0.5
        let borderColor = UIColor.blue.cgColor
        
        self.leftBtn.tag = -1 // 태그값에 - 부여
        self.leftBtn.setTitle(self.leftTitle, for: .normal)
        self.leftBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.leftBtn.layer.borderWidth = borderWidth
        self.leftBtn.layer.borderColor = borderColor
        
        self.rightBtn.tag = 1
        self.rightBtn.setTitle(self.rightTitle, for: .normal)
        self.rightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.rightBtn.layer.borderWidth = borderWidth
        self.rightBtn.layer.borderColor = borderColor
        
        self.centerLabel.text = String(value)
        self.centerLabel.font = UIFont.systemFont(ofSize: 16)
        self.centerLabel.textAlignment = .center
        self.centerLabel.backgroundColor = self.bgColor
        
        self.centerLabel.layer.borderWidth = borderWidth
        self.centerLabel.layer.borderColor = borderColor
        
        self.addSubview(leftBtn)
        self.addSubview(rightBtn)
        self.addSubview(centerLabel)
    }
    
    
    //Custom Steper의 레이아웃을 지정해주는 메서드를 구현한다.
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        //버튼의 너비 = 뷰 높이
        let btnWidth = self.frame.height
        
        //레이블의 너비 = 뷰 전체 크기 - 양쪽 버튼의 너비 합
        let lbWidth = self.frame.width - (btnWidth*2)
        
        //각 뷰별로 프레임 사이즈를 정함
        self.leftBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth)
        self.centerLabel.frame = CGRect(x: btnWidth, y: 0, width: lbWidth, height: btnWidth)
        self.rightBtn.frame = CGRect(x: btnWidth+lbWidth, y: 0, width: btnWidth, height: btnWidth)
        
        self.leftBtn.addTarget(self, action: #selector(valueChange(_:)), for: .touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(valueChange(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(logging(_:)), for: .valueChanged)
        
    }
    
    @objc func logging(_ sender:CSStepper) {
        NSLog("현재 스태퍼의 값은 \(sender.value) 입니다.")
    }
    
    
    @objc public func valueChange(_ sender:UIButton) {
        
        //버튼의 태그 값에 +, - 를 기재해 주었기 때문에 해당 값을 그대로 불러온다.
       let sum =  self.value + (sender.tag * self.stepValue)
        
        if sum > self.maximumValue {
            return
        }
        
        if sum < self.minimumValue {
            return
        }
        
        self.value += (sender.tag * self.stepValue)
        
    }
    
}
