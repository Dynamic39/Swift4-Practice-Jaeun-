//
//  UserInfoKey.swift
//  Chapter05-CustomPlist
//
//  Created by Samuel K on 2018. 3. 5..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

struct UserInfoKey {
    
    //UserDefaults에 사용될 키값
    static let loginID = "LOGINID"
    static let account = "ACCOUNT"
    static let name = "NAME"
    static let profile = "PROFILE"
    
}

//계정 및 사용자 정보를 저장 관리 하는 클래스
class UserInfoManager {
    
    //연산 프로퍼티 loginId정의
    var loginID: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserInfoKey.loginID)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.loginID)
            ud.synchronize()
        }
    }
    
    //연산 프로퍼티 account 정의
    var account: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.account)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.account)
            ud.synchronize()
        }
    }
    
    var name: String? {
        
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.name)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.name)
            ud.synchronize()
        }
    }
    
    var profile: UIImage? {
        get {
            let ud = UserDefaults.standard
            if let realProfile = ud.data(forKey: UserInfoKey.profile) {
                return UIImage(data: realProfile)
            } else {
                return UIImage(named: "account.jpg")
            }
        }
        set(v) {
            if v != nil {
                let ud = UserDefaults.standard
                ud.set(UIImagePNGRepresentation(v!), forKey: UserInfoKey.profile)
                ud.synchronize()
            }
        }
    }
    
    var isLogin: Bool {
        if self.loginID == 0 || self.account == nil {
            return false
        } else {
            return true
        }
    }
    
    //login 메서드 구현
    func login(account:String, password:String) -> Bool
    {
        if account.isEqual("sky4411v@gmail.com") && password.isEqual("rkd1234")
        {
            let ud = UserDefaults.standard
            ud.set(100, forKey: UserInfoKey.loginID)
            ud.set(account, forKey: UserInfoKey.account)
            ud.set("삼규 님", forKey: UserInfoKey.name)
            ud.synchronize()
            
            return true
        } else
        {
            return false
        }
    }
    
    //LogOut메서드 구현
    func logout() -> Bool
    {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: UserInfoKey.loginID)
        ud.removeObject(forKey: UserInfoKey.account)
        ud.removeObject(forKey: UserInfoKey.name)
        ud.removeObject(forKey: UserInfoKey.profile)
        ud.synchronize()
        return true
    }
    
    
    
    
}
