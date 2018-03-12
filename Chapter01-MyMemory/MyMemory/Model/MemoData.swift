//
//  MemoData.swift
//  MyMemory
//
//  Created by Samuel K on 2017. 10. 30..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import Foundation
import UIKit

import CoreData


class MemoData {
    
    var memoIdx: Int? //데이터 식별값
    var title:String? //메모 제목
    var contents:String? // 메모 내용
    var image:UIImage? // 이미지
    var regdate:Date? // 작성일
    
    //코어 데이터를 이용하여 데이터를 저장한다.
    var objectID: NSManagedObjectID?
    
}

