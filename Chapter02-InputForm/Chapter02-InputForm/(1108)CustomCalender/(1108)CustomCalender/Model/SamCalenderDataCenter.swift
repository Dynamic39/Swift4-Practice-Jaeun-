//
//  SamCalenderDataCenter.swift
//  (1108)CustomCalender
//
//  Created by Samuel K on 2017. 11. 8..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import Foundation


//WeekDay숫자에 따른, 각 요일을 설정할 수 있는 enum 함수를 만든다.
enum weekDay:Int {
    case Sun=0,Mon,Tue,Wed,Thu,Fri,Sat
    
    
    var name:String {
        
        switch self {
        case .Sun:
            return "Sun"
        case .Mon:
            return "Mon"
        case .Tue:
            return "Tue"
        case .Wed:
            return "Wed"
        case .Thu:
            return "Thu"
        case .Fri:
            return "Fri"
        case .Sat:
            return "Sat"
        }
    }
}

class SamCalenderManager {
    
    class func nextMonth(with dateModel:SamCalendarDataModel) -> Date {
        
        //모델을 받아서 다음달이 어떤지를 알려주는 월을 반환해줌
        
        let calendarIns = Calendar(identifier: .gregorian)
        
        //마지막 날에 대한 값을 넣어준다.
        var newComponents = DateComponents()
        newComponents.year = dateModel.year
        newComponents.month = dateModel.month + 1
        newComponents.day = dateModel.day
        
        if let nextDate = calendarIns.date(from: newComponents)
        {
            return  nextDate
        }else{
            return Date()
        }
    }
    
    class func preMonth(with dateModel:SamCalendarDataModel) -> Date {
        
        //모델을 받아서 다음달이 어떤지를 알려주는 월을 반환해줌
        
        let calendarIns = Calendar(identifier: .gregorian)
        
        //마지막 날에 대한 값을 넣어준다.
        var newComponents = DateComponents()
        newComponents.year = dateModel.year
        newComponents.month = dateModel.month - 1
        newComponents.day = dateModel.day
        
        if let preDate = calendarIns.date(from: newComponents)
        {
            return  preDate
        }else{
            return Date()
        }
    }
    
}

//달력을 만들기 위한, 데이터 모델링 작업을 진행한다.

struct SamCalendarDataModel {
    
    var year:Int
    var month:Int
    var day:Int
    
    var startWeekOfMonth:weekDay
    var lastDayOfMonth:Int

    init?(date:Date) {
        
        //날짜 데이터를 입력함
        
        let calendarIns = Calendar(identifier: .gregorian)
        
        //데이터의 특정 인스턴스를 불러온다.
        var components = calendarIns.dateComponents([.year, .month, .day], from: date)
        
        //test -> 수동/특정일자 강제 입력잼
        year = components.year ?? 0
        month = components.month ?? 0
        day = components.day ?? 0
        components.day = 1
        
        //1일이 시작될때, 무슨 요일인지 아는 로직을 구현한다.
        guard let firstDayDate =  calendarIns.date(from: components) else {return nil}
        
        //요일에 해당하는 값을 반환해준다(1이 일요일)
        var weekDayCompo = calendarIns.dateComponents([.weekday], from: firstDayDate)
        startWeekOfMonth = weekDay.init(rawValue: weekDayCompo.weekday! - 1)!
        
        //마지막 날에 대한 값을 넣어준다.
        var addComponents = DateComponents()
        addComponents.month = 1
        addComponents.day = -1
        
        //처음 시작 날부터 마지막이 몇일인지를 확인하는 로직을 구현한다.
        guard let lastDayDate = calendarIns.date(byAdding: addComponents, to: firstDayDate) else {return nil}
        lastDayOfMonth = calendarIns.dateComponents([.day], from: lastDayDate).day!
    
//        startWeekOfMonth = .Wed
//        lastDayOfMonth = 30
        
    }
}
