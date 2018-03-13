//
//  JoinVC.swift
//  MyMemory
//
//  Created by Samuel K on 2018. 3. 13..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit
import Alamofire

class JoinVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    //테이블 뷰에 들어갈 텍스트 필드들
    var fieldAccout: UITextField! // 계정 필드
    var fieldPassword: UITextField! // 비밀번호 필드
    var fieldName: UITextField! // 이름 필드
    
    //중복 송신 불가처리
    var isCalling = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //프로필 이미지 둥글게 해줌
        self.profile.layer.cornerRadius = self.profile.frame.width / 2
        self.profile.layer.masksToBounds = true
        self.view.bringSubview(toFront: indicatorView)
        indicatorView.isHidden = true
        
        addGestureToProfileImage()
        
        
    }
    
    //MARK: - Func Methods
    //프로필 이미지에 탭제스쳐 및 이벤트 설정
    func addGestureToProfileImage() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedProfile(_:)))
        self.profile.addGestureRecognizer(gesture)
    }
    
    //MARK: - @objc Action Methods
    @objc func tappedProfile(_ sender:Any) {
        
        let msg = "프로필 이미지를 읽어올 곳을 선택하세요"
        let sheet = UIAlertController(title: msg, message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "저장된 앨범", style: .default, handler: { (_) in
            selectLibrary(src: .savedPhotosAlbum) // 저장된 앨범에서 가지고 오기
        }))
        sheet.addAction(UIAlertAction(title: "포토 라이브러리", style: .default, handler: { (_) in
            selectLibrary(src: .photoLibrary) // 포토 라이브러리에서 가지고 오기
        }))
        sheet.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (_) in
            selectLibrary(src: .camera) // 카메라에서 가지고 오기
        }))
        
        func selectLibrary(src: UIImagePickerControllerSourceType) {
            
            if UIImagePickerController.isSourceTypeAvailable(src) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: false, completion: nil)
                
            } else {
                self.alert("사용 할 수 없는 타입니다.")
            }
        }
        
        self.present(sheet, animated: false, completion: nil)
        
        
        
    }
    
    //MARK: - Action Methods
    @IBAction func submit(_ sender: Any) {
        
        if self.isCalling == true {
            self.alert("진행중입니다. 잠시만 기다려주세요")
            return
        } else {
            self.isCalling = true
        }
        //인디케이터 애니메이션 시작
        self.indicatorView.isHidden = false
        self.indicatorView.startAnimating()
        //1. 전달할 값 준비
        //1-1. 이미지를 base64 인코딩 처리
        let profile = UIImagePNGRepresentation(self.profile.image!)?.base64EncodedString()
        
        //1-2. 전달값을 parameters 타입으로 정의한다.
        let param:Parameters = [
            "account" : self.fieldAccout.text!,
            "passwd": self.fieldPassword.text!,
            "name":self.fieldName.text!,
            "profile_image":profile!
        ]
        
        //2. API 호출
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/join"
        let call = Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil)
        
        //3. 서버 응답값 설정
        call.responseJSON { (res) in
            //인디케이터 종료
            self.indicatorView.isHidden = true
            self.indicatorView.stopAnimating()
            //3-1. JSON형식으로 제대로 전달되었는지 확인
            guard let jsonObject = res.result.value as? [String:Any] else {
                self.isCalling = false
                self.alert("서버 호출 과정에서 오류가 발생했습니다.")
                return
            }
            
            //3-2. 응답 코드 확인 0이면 성공
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0 {
                self.alert("가입이 완료되었습니다.")
            } else {
                let errorMsg = jsonObject["error_msg"] as! String
                self.alert("오류 발생 : \(errorMsg)")
                self.isCalling = false
                print(res.result.value)
            }
            
        }
        
        
    }
    
    //MARK: -TableView Methods
    
    //높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    //TextField 상세값 설정
    func createNewTF(tfName:String, cell:UITableViewCell, secureMode:Bool = false) -> UITextField {
        
        let tfFrame = CGRect(x: 20, y: 0, width: cell.bounds.width - 20, height: 37)
        let textField = UITextField(frame: tfFrame)
        textField.placeholder = tfName
        textField.borderStyle = .none
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = secureMode
        textField.font = UIFont.systemFont(ofSize: 14)
        
        return textField
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        //각각 셀별로 다른 값들을 넣어줌
        switch indexPath.row {
        case 0:
            fieldAccout = createNewTF(tfName: "계정(이메일)", cell: cell)
            cell.addSubview(fieldAccout)
        case 1:
            fieldPassword = createNewTF(tfName: "비밀번호", cell: cell, secureMode: true)
            cell.addSubview(fieldPassword)
        case 2:
            fieldName = createNewTF(tfName: "이름", cell: cell)
            cell.addSubview(fieldName)
        default:
            print("Fatal Error In TableView Cell Create")
        }

        return cell
    }
    
    //MARK: - UIIMagePickerMethods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profile.image = img
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
