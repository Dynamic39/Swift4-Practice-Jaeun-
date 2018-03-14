//
//  UserInfoKey.swift
//  Chapter05-CustomPlist
//
//  Created by Samuel K on 2018. 3. 5..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit
import Alamofire

struct UserInfoKey {
    
    //UserDefaults에 사용될 키값
    static let loginID = "LOGINID"
    static let account = "ACCOUNT"
    static let name = "NAME"
    static let profile = "PROFILE"
    static let tutorial = "TUTORIAL"
    
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
    func login(account:String, password:String, success: (()->Void)? = nil, fail:((String)->Void)? = nil)
    {
        //1. URL과 전송할 값 준비
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/login"
        let param:Parameters = [
            "account" : account,
            "passwd" : password,
        ]
        //2. API 호출
        let call = Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil)
        //3. 호출 결과 처리
        call.responseJSON { (res) in
            //3-1. JSON형식으로 응답하였는지 확인
            guard let jsonObject = res.result.value as? NSDictionary else {
                fail?("잘못된 응답 형식입니다 : \(res.result.value!)")
                return
            }
            //3-2. 응답 코드 확인 0이면 성공
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0  {
                //로그인 성공
                //3-3. 로그인 성공 처리 로직이 여기에 들어갑니다.
                let user = jsonObject["user_info"] as! NSDictionary
                self.loginID = user["user_id"] as! Int
                self.account = user["account"] as? String
                self.name = user["name"] as? String
                
                //3-4. user_info 항목 중에서 프로필 이미지 처리
                if let path = user["profile_path"] as? String {
                    if let imageData = try? Data(contentsOf: URL(string: path)!) {
                        self.profile = UIImage(data: imageData)
                    }
                }
                success?()
                
            } else {
                let msg = (jsonObject["error_msg"] as? String) ?? "로그인이 실패했습니다."
                fail?(msg)
            }
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
