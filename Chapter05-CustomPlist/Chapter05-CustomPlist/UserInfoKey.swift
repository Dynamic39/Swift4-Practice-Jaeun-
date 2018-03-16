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
    
    //프로필 사진 변경 메서드 구현
    func newProfile(_ profile:UIImage?, success: (()->Void)? = nil, fail:((String)->Void)? = nil) {
        
        //1. API 호출
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/profile"
        
        //2. 인증 헤더
        let tk = TokenUtils()
        let header = tk.getAuthorizationHeader()
        
        //3. 전송할 프로파일 이미지
        let profileData = UIImagePNGRepresentation(profile!)?.base64EncodedString()
        let param:Parameters = ["profile_image": profileData!]
        
        //4. 이미지 전송
        let call = Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header)
        call.responseJSON { (res) in
            guard let jsonObject = res.result.value as? NSDictionary else {
                fail?("올바른 응답값이 아닙니다.")
                return
            }
            
            //응답 코드 확인 0이면 성공
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0 {
                self.profile = profile
                success?()
            } else {
                let msg = (jsonObject["error_msg"] as? String) ?? "이미지 프로필 변경이 실패했습니다."
                fail?(msg)
            }
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
                
                // 토큰 정보 추출
                let accessToken = jsonObject["access_token"] as! String // 액세스 토큰 추출
                let refreshToken = jsonObject["refresh_token"] as! String // 리프레시 토큰 추출
                
                //토큰 정보 저장
                let tk = TokenUtils()
                tk.save("kr.co.rubypaper.MyMemory", account: "accessToken", value: accessToken)
                tk.save("kr.co.rubypaper.MyMemory", account: "refreshToken", value: refreshToken)

                //3-4 인자값으로 입력된 클로저 블록 실행
                success?()
                
            } else {
                let msg = (jsonObject["error_msg"] as? String) ?? "로그인이 실패했습니다."
                fail?(msg)
            }
        }
    }
    
    //LogOut메서드 구현
    func logout(completion: (()->Void)? = nil) -> Bool
    {
    
        //1. 호출 URL
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/logout"
        
        //2. 인증 헤더 구현
        let tokenUtils = TokenUtils()
        let header = tokenUtils.getAuthorizationHeader()
        
        //3. API 호출 및 응답처리
        let call = Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
        
        call.responseJSON { (_) in
            //3-1 서버로부터 응답이 온 후, 처리할 동작을 여기에 작성
            self.localLogout()
            completion?()
        }
        
        return true
    }
    
    //Local Logout 구현
    func localLogout() {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: UserInfoKey.loginID)
        ud.removeObject(forKey: UserInfoKey.account)
        ud.removeObject(forKey: UserInfoKey.name)
        ud.removeObject(forKey: UserInfoKey.profile)
        
        //키 체인에 저장된 값을 삭제
        let tokenUtils = TokenUtils()
        tokenUtils.delete("kr.co.rubypaper.MyMemory", account: "refreshToken")
        tokenUtils.delete("kr.co.rubypaper.MyMemory", account: "accessToken")
    }
    
    
    
    
}
