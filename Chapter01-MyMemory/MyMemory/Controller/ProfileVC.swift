//
//  ProfileVC.swift
//  MyMemory
//
//  Created by Samuel K on 2018. 2. 23..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit
import Alamofire
import LocalAuthentication

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  let profileImage = UIImageView()
  let tv = UITableView()
  let uinfo = UserInfoManager()
  
  //중복 방지 관리 변수
  var isCalling = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    backBtn()
    personalAccount()
    backGroundImageMake()
    
    tv.dataSource = self
    tv.delegate = self
    self.drawBtn()
    self.navigationController?.navigationBar.isHidden = true
    changeProfileImage()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tokenValidate()
  }
  
  @IBAction func backProfileVC(_ segue: UIStoryboardSegue) {
    
    //프로필 화면으로 되돌아오기 위한 역할
    //아무내용도 작성하지 않음
    
  }
  
  //탭 했을시 제스쳐 동작으로 시행 될 수 있도록 한다.
  func changeProfileImage() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(profile(_:)))
    self.profileImage.addGestureRecognizer(tap)
    self.profileImage.isUserInteractionEnabled = true
  }
  
  //이미지피커를 이용한, 사진 변경기능 구현
  func imgPicker(_ source: UIImagePickerControllerSourceType) {
    
    let picker = UIImagePickerController()
    picker.sourceType = source
    picker.delegate = self
    picker.allowsEditing = true
    self.present(picker, animated: true, completion: nil)
  }
  
  //profile 을 구성하기 위한 메서드
  @objc func profile(_ sender: UIButton) {
    
    guard self.uinfo.account != nil else {
      self.doLogin(self)
      return
    }
    
    let alert = UIAlertController(title: nil, message: "사진을 가져올 곳을 선택하세요", preferredStyle: .actionSheet)
    
    //카메라 사용시
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (_) in
        //카메라 기능 호출
        self.imgPicker(.camera)
      }))
    }
    //앨범 사용 가능시
    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
      alert.addAction(UIAlertAction(title: "앨범", style: .default, handler: { (_) in
        self.imgPicker(.savedPhotosAlbum)
      }))
    }
    //포토라이브러리 사용 가능시
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default, handler: { (_) in
        self.imgPicker(.photoLibrary)
      }))
    }
    //캔슬 버튼 추가
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    self.present(alert, animated: true, completion: nil)
    
    
    
  }
  
  //사진이 선택되면 자동으로 호출될 메서드
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    //네트워크 인디케이터 실행
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    picker.dismiss(animated: true, completion: nil)
    
  }
  //로그인 화면 만들기
  @objc func doLogin(_ sender:Any) {
    
    //상태 체크
    if isCalling {
      self.alert("응답을 기다리는 중입니다. \n잠시만 기다려 주세요.")
      return
    } else {
      isCalling = true
    }
    
    let loginAlert = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
    
    //아이디와 패스워드 텍스트 필드를 설정한다.
    loginAlert.addTextField { (tf) in
      tf.placeholder = "Your Account!"
    }
    
    loginAlert.addTextField { (tf) in
      tf.placeholder = "Password"
      tf.isSecureTextEntry = true
    }
    loginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {(_) in
      self.isCalling = false
    })
    loginAlert.addAction(UIAlertAction(title: "Login", style: .destructive, handler: { (_) in
      
      //상태바 안에 인디케이터 활성화하기
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      
      let account = loginAlert.textFields?[0].text ?? "" // 첫번째 필드 계정
      let passwd = loginAlert.textFields?[1].text ?? "" // 두번째 필드 비밀번호
      
      //로그인 프로세스 설정
      //성공하면 클로져를 실행하기 때문에, 클로져가 실행되었을때 작업을 진행하여 준다(비동기 처리)
      self.uinfo.login(account: account, password: passwd, success: {
        self.tv.reloadData()
        self.profileImage.image = self.uinfo.profile
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.isCalling = false
      }, fail: { (msg) in
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.isCalling = false
        self.alert(msg)
      })
      
    }))
    
    self.present(loginAlert, animated: false)
    
  }
  
  @objc func doLogout(_ sender:Any) {
    let msg = "로그아웃 하시겠습니까?"
    let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "취소", style: .cancel))
    alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
      
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      
      self.uinfo.logout(completion: {
        //로그아웃이 성공하였을 때 정보를 갱신한다.
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        self.tv.reloadData()
        self.profileImage.image = self.uinfo.profile
        self.drawBtn()
      })
      
    }))
    self.present(alert, animated: false, completion: nil)
  }
  
  func drawBtn() {
    
    //버튼을 감쌀 뷰를 설정한다.
    let v = UIView()
    v.frame.size.width = self.view.frame.width
    v.frame.size.height = 40
    v.frame.origin.x = 0
    v.frame.origin.y = self.tv.frame.origin.y + self.tv.frame.height
    v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
    
    self.view.addSubview(v)
    
    //버튼을 정의함
    let btn = UIButton(type: .system)
    btn.frame.size.width = 100
    btn.frame.size.height = 30
    btn.center.x = v.frame.size.width / 2
    btn.center.y = v.frame.size.height / 2
    
    //로그인 유무에 따른 버튼 온/오프으로 활성화
    if self.uinfo.isLogin == true {
      btn.setTitle("로그아웃", for: .normal)
      btn.addTarget(self, action: #selector(doLogout(_:)), for: .touchUpInside)
    } else {
      btn.setTitle("로그인", for: .normal)
      btn.addTarget(self, action: #selector(doLogin(_:)), for: .touchUpInside)
    }
    
    v.addSubview(btn)
  }
  
  func backGroundImageMake() {
    let bg = UIImage(named: "profile-bg.png")
    let bgImg = UIImageView(image: bg)
    
    bgImg.frame.size = CGSize(width: bgImg.frame.size.width, height: bgImg.frame.size.height)
    bgImg.center = CGPoint(x: self.view.frame.width / 2, y: 40)
    bgImg.layer.cornerRadius = bgImg.frame.size.width / 2
    bgImg.layer.borderWidth = 0
    bgImg.layer.masksToBounds = true
    
    self.view.addSubview(bgImg)
    
    //순서가 뒤로 될 수 있도록 다른 뷰들을 앞으로 가져온다.
    self.view.bringSubview(toFront: self.tv)
    self.view.bringSubview(toFront: self.profileImage)
    
  }
  
  func personalAccount() {
    
    //이미지 입력
    let image = self.uinfo.profile
    
    self.profileImage.image = image
    self.profileImage.frame.size = CGSize(width: 100, height: 100)
    self.profileImage.center = CGPoint(x: self.view.frame.width/2, y: 270)
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
    self.profileImage.layer.borderWidth = 0
    self.profileImage.layer.masksToBounds = true
    
    self.view.addSubview(self.profileImage)
    
    //테이블 뷰
    
    tv.frame = CGRect(x: 0, y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20, width: self.view.frame.width, height: 100)
    
    self.view.addSubview(self.tv)
    
  }
  
  func backBtn() {
    let backBtn = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(close))
    self.navigationItem.leftBarButtonItem = backBtn
  }
  
  @objc func close(_ sender: Any) {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 2
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
    
    cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
    cell.accessoryType = .disclosureIndicator
    
    switch indexPath.row {
    case 0:
      cell.textLabel?.text = "이름"
      cell.detailTextLabel?.text = self.uinfo.name ?? "Login Please"
    case 1:
      cell.textLabel?.text = "계정"
      cell.detailTextLabel?.text = self.uinfo.account ?? "Login Please"
    default:
      print("Fatal Error in Switch")
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if self.uinfo.isLogin == false {
      self.doLogin(self.tv)
    }
  }
}


//TouchID를 사용하여, 토큰인증 및 재갱신을 실행함.
extension ProfileVC {
  
  //토큰 유효성 체크
  func tokenValidate() {
    //0. 응답 캐시를 사용하지 않도록 한다.
    URLCache.shared.removeAllCachedResponses()
    
    //1. 키 체인에 액세스 토큰이 없을 경우, 유효성 검증을 진행하지 않음.
    let tk = TokenUtils()
    guard let header = tk.getAuthorizationHeader() else { return }
    UIApplication.shared.isNetworkActivityIndicatorVisible = true // 로딩 시작
    
    //2. TokenValidate API를 호출한다.
    let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/tokenValidate"
    let validate = Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header)
    
    validate.responseJSON { (res) in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      
      print(res.result.value!) // 2-1 응답 결과를 확인하기 위해 메시지 본문 전체 출력
      guard let jsonObject = res.result.value as? NSDictionary else {
        self.alert("잘못된 응답입니다.")
        return
      }
      //3. 응답 결과 처리
      let resultCode = jsonObject["result_code"] as! Int
      //3-1. 응답 결과 실패, 즉 토큰 만료시
      if resultCode != 0 {
        //로컬 인증 실행
        self.touchID()
      }
    }
  }
  
  func touchID() {
    //1. LAContext 생성
    let context = LAContext()
    
    //2. 로컬 인증에 사용할 변수 정의
    var error:NSError?
    let msg = "인증이 필요합니다."
    //인증정책
    let deviceAuth = LAPolicy.deviceOwnerAuthenticationWithBiometrics
    
    //3. 로컬 인증이 사용 가능한지 여부 확인
    if context.canEvaluatePolicy(deviceAuth, error: &error) {
      context.evaluatePolicy(deviceAuth, localizedReason: msg, reply: { (success, e) in
        if success {
          //5-1 토큰 갱신 로직 실행
          self.refresh()
        } else {
          //6. 인증 실패
          //실패 원인에 따른 대체 메시지 발송
          print(e?.localizedDescription)
          
          switch (e!._code) {
          case LAError.systemCancel.rawValue:
            self.alert("시스템에 의해 인증이 취소되었습니다.")
          case LAError.userCancel.rawValue:
          self.alert("사용자에 의해 인증이 취소되었습니다.")
          case LAError.userFallback.rawValue:
            OperationQueue.main.addOperation {
              self.commonLogout(true)
            }
          default:
            OperationQueue.main.addOperation {
              self.commonLogout(true)
            }
          }
        }
      })
    } else {
      print(error!.localizedDescription)
      
      switch (error!.code) {
      case LAError.touchIDNotEnrolled.rawValue:
        print("터치아이디가 등록되어 있지 않습니다.")
      case LAError.passcodeNotSet.rawValue:
        print("패스 코드가 설정되어 있지 않습니다.")
      default:
        print("터치 아이디를 사용 할 수 없습니다.")
        OperationQueue.main.addOperation {
          self.commonLogout(true)
        }
      }
    }
  }
  
  //새로운 토큰을 받는 로직
  func refresh() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    //1. 인증헤더
    let tk = TokenUtils()
    let header = tk.getAuthorizationHeader()
    
    //2. 리프레시 토큰 전달 준비
    let refreshToken = tk.load("kr.co.rubypaper.MyMemory", account: "refreshToken")
    let param: Parameters = ["refresh_token": refreshToken!]
    
    //3. 호출 및 응답
    let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/refresh"
    let refresh = Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header)
    
    refresh.responseJSON { (res) in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      
      guard let jsonObject = res.result.value as? NSDictionary else {
        self.alert("잘못된 응답입니다.")
        return
      }
      //4. 응답 결과 처리
      let resultCode = jsonObject["result_code"] as! Int
      if resultCode == 0 {
        //4-1 키체인 등록 처리
        let acccessToken = jsonObject["access_token"] as! String
        tk.save("kr.co.rubypaper.MyMemory", account: "accessToken", value: acccessToken)
      } else { // 실패
        self.alert("인증이 만료되었습니다. 다시 로그인해야 합니다.") {
          //4-2 로그 아웃 처리
          OperationQueue.main.addOperation {
            self.commonLogout(true)
          }
        }
      }
    }
  }
  
  //예외처리를 위한 로그아웃
  func commonLogout(_ isLogin:Bool = false) {
    //1. 저장된 기존 정보, 키체인 데이터 삭제
    let userInfo = UserInfoManager()
    userInfo.localLogout()
    //2. 현재의 화면이 프로필 화면이라면 바로 UI를 갱신한다.
    self.tv.reloadData()
    self.profileImage.image = userInfo.profile
    self.drawBtn()
    
    if isLogin {
      self.doLogin(self)
    }
    
    
  }
}
  

  


