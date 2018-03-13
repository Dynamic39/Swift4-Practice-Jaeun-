//
//  ViewController.swift
//  Chapter08-APITest
//
//  Created by Samuel K on 2018. 3. 13..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    
    @IBOutlet weak var currentTime: UILabel!
    
    //Post API 호출 관련
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var responseView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //JSON 통신
    @IBAction func json(_ sender: Any) {
        
        //1. 전송할 값 준비
        let userId = (self.userId.text)!
        let name = (self.name.text)!
        
        //JSON형식 변환
        let param = ["userId": userId, "name": name]
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        //2. URL 객체 정의
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echoJSON")
        
        //3. URLRequest 객체 정의 및 요청 내용 담기
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        //4. HTTP메시지 헤더 설정
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        //5-1. URLSession 객체를 통해 전송 및 응답값 처리 로직 작성
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let e = error {
                NSLog("An error has occurred: \(e.localizedDescription)")
                return
            }
            //5-2응답 처리 로직 들어감
            //1) 메인스레드에서 비동기 처리되게 한다.
            DispatchQueue.main.async {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else { return }
                    
                    //2) JSON 결과값 추출
                    let result = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String
                    
                    if result == "SUCCESS" {
                        self.responseView.text = "아이디 : \(userId!)" + "\n"
                            + "이름 : \(name!)" + "\n"
                            + "응답결과 : \(result!)" + "\n"
                            + "응답시간 : \(timestamp!)" + "\n"
                            + "요청방식 : x-www-form-urlencoded"
                    }
                } catch let e as NSError {
                    print("An error has occurred while parsin JSONObejct : \(e.localizedDescription)")
                }
            }
            
        }
        //6. POST 전송
        task.resume()
        
        
        
        
    }
    
    //POST 통신
    @IBAction func post(_ sender: Any) {
        
        //1. 전송할 값 준비
        let userId = (self.userId.text)!
        let name = (self.name.text)!
        let param = "userId=\(userId)&name=\(name)"
        let paramData = param.data(using: .utf8) // 전송과정에서 유실되지 않도록 한번더 인코딩 해줌.
        
        //2. URL 객체 정의
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echo")
        
        //3. URLRequest 객체 정의 및 요청 내용 담기
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        //4. HTTP메시지 헤더 설정
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        //5-1. URLSession 객체를 통해 전송 및 응답값 처리 로직 작성
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let e = error {
                NSLog("An error has occurred: \(e.localizedDescription)")
                return
            }
            //5-2응답 처리 로직 들어감
            //1) 메인스레드에서 비동기 처리되게 한다.
            DispatchQueue.main.async {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else { return }
                    
                    //2) JSON 결과값 추출
                    let result = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String
                    
                    if result == "SUCCESS" {
                        self.responseView.text = "아이디 : \(userId!)" + "\n"
                                                + "이름 : \(name!)" + "\n"
                                                + "응답결과 : \(result!)" + "\n"
                                                + "응답시간 : \(timestamp!)" + "\n"
                                                + "요청방식 : application/json"
                    }
                } catch let e as NSError {
                    print("An error has occurred while parsin JSONObejct : \(e.localizedDescription)")
                }
            }

        }
        //6. POST 전송
        task.resume()
        
        
        //Alamofire POST
        alamofirePOST(userId: userId, userName: name)
        
        
    }
    
    //Alamofire POST
    func alamofirePOST(userId: String, userName:String) {
        
        let url = "http://swiftapi.rubypaper.co.kr:2029/practice/echo"
        let param:Parameters = [
            "userId":userId,
            "name":userName
        ]
        let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil)
        
        alamo.responseJSON { (response) in
            print("JSON=\(response.result.value!)")
            if let jsonObject = response.result.value as?  [String:Any] {
                print("userId = \(jsonObject["userId"]!)")
                print("name = \(jsonObject["name"]!)")
            }
        }
    }
    
    
    //GET 통신
    @IBAction func callCurrentTime(_ sender: Any) {

        do {
            //서버 통신
            let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime")
            let response = try String(contentsOf: url!)
            self.currentTime.text = response
            self.currentTime.sizeToFit()
        } catch let e as NSError {
            print(e.localizedDescription)
        }
 
 
        //Alamofire 방식으로 전송
        let url = "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime"
        Alamofire.request(url).responseString { (response) in
            print("Alamofire 성공여부 : \(response.result.isSuccess)")
            print("Alamofire 결과값 : \(response.result.value!)")
        }   
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

