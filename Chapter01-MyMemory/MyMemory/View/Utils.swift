//
//  Utils.swift
//  MyMemory
//
//  Created by Samuel K on 2018. 3. 6..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import Foundation
import Security
import Alamofire


//Apple KeyChain에 OAuth 인증을 통해 전달 된 토큰을 저장하는 메서드를 구현한다.

class TokenUtils {
    
    //키체인에 값을 저장하는 메서드
    func save(_ service: String, account: String, value: String) {
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service,
            kSecAttrAccount : account,
            kSecValueData : value.data(using: .utf8, allowLossyConversion: false)!
        ]
        
        //현재 저장되어 있는 값 삭제
        SecItemDelete(keyChainQuery)
        
        //새로운 키 체인 아이템 등록
        let status: OSStatus =  SecItemAdd(keyChainQuery, nil)
        assert(status == noErr, "토큰 값 저장에 실패했습니다.")
        NSLog("status=\(status)")
    }
    
    //키체인에 저장된 값을 읽어오는 메서드 정의
    func load(_ service: String, account:String) -> String? {
        //1. 키체인 쿼리 정의
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service,
            kSecAttrAccount : account,
            kSecValueData : kCFBooleanTrue, // CFDataRef
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        //2. 키 체인에 저장된 값을 읽어옴
        var dataTypeRef : AnyObject?
        let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
        
        //3. 처리 결과가 성공이라면, 값을 Data타입으로 변환하고, 다시 String 타입으로 변환한다.
        if (status == errSecSuccess) {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        } else { // 처리결과가 실패라면 nil반환
            print("Nothing was retrieved from the KeyChain. Status code \(status)")
            return nil
        }
    }
    
    func delete(_ service: String, account: String) {
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
        
        let status = SecItemDelete(keyChainQuery)
        assert(status == noErr, "토큰 값 삭제에 실패하였습니다.")
        NSLog("status=\(status)")
    }
    
    //키 체인에 저장된 엑세스 토큰을 이용하여 헤더를 만들어주는 메서드
    func getAuthorizationHeader() -> HTTPHeaders? {
        let serviceID = "kr.co.rubypaper.MyMemory"
        if let accessToken = self.load(serviceID, account: "accessToken") {
            return ["Authorization":"Bearer\(accessToken)"] as HTTPHeaders
        } else {
            return nil
        }
    }
    
    
}


extension UIViewController {
    
    //Tutorial storyboard를 쉽게 만들기 위하여 extension을 사용하여, UIViewController를 확장하여 준다.
    var turorialSB: UIStoryboard {
        return UIStoryboard(name: "Tutorial", bundle: Bundle.main)
    }
    
    func instanceTutorialVC(name: String) -> UIViewController? {
        return self.turorialSB.instantiateViewController(withIdentifier: name)
    }
    
    //Alert기능을 어디서든지 활용할 수 있게 간소화 하여 준다.
    func alert(_ message:String, completion: (()->Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel, handler: { (_) in
                completion?() // completion의 매개변수의 값이 nil이 아닐때에만 실행되도록
            })
            alert.addAction(okAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
}
