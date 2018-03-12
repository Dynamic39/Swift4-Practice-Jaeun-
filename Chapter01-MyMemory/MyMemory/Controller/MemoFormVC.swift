//
//  MemoFormVC.swift
//  MyMemory
//
//  Created by Samuel K on 2017. 10. 30..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit

class MemoFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    var subject:String!
    lazy var dao = MemoDAO() // 메모 코어 데이터 인스턴스 생성
    
    @IBOutlet var contents: UITextView!
    @IBOutlet var preview: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contents.delegate = self
        
        //백그라운드 설정
        let bgImage = UIImage(named: "memo-background")!
        self.view.backgroundColor = UIColor(patternImage: bgImage)
        
        //텍스트뷰의 기본 속성
        self.contents.layer.borderWidth = 0
        self.contents.layer.borderColor = UIColor.clear.cgColor
        self.contents.backgroundColor = UIColor.clear
        
        //줄간격 설정
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 9
        self.contents.attributedText = NSAttributedString(string: " ", attributes: [NSAttributedStringKey.paragraphStyle: style])
        self.contents.text = ""
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //네비게이션 바 설정
        let bar = self.navigationController?.navigationBar
        //네비게이션 타임 인터벌 설정
        let ts = TimeInterval(0.3)
        //애니메이션 효과 설정
        UIView.animate(withDuration: ts) {
            //네비게이션의 알파값이 터치의 반응에 따라, 1 ~ 0 으로 조절된다.
            bar?.alpha = (bar?.alpha == 0 ? 1 : 0)
        }
    }
    
    @IBAction func pick(_ sender: Any) {
        
        let alert:UIAlertController = UIAlertController(title: "다음 중 선택하여 주십시오.", message: nil, preferredStyle: .actionSheet)
        
        let fromAlbum:UIAlertAction = UIAlertAction(title: "저장앨범", style: .default) { (action) in
            print("실제 실행 내용")
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.allowsEditing = true
            
            self.present(picker, animated: false, completion: nil)
            
        }
        
        let cameraAction = UIAlertAction(title: "사진", style: .default, handler: nil)
        let fromLibrary = UIAlertAction(title: "사진 라이브러", style: .default, handler: nil)
        
        alert.addAction(fromAlbum)
        alert.addAction(cameraAction)
        alert.addAction(fromLibrary)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    //이미지 선택을 완료했을때 나타나는 메소드
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.preview.image = info[UIImagePickerControllerEditedImage] as? UIImage
        picker.dismiss(animated: false, completion: nil)
        
        
    }
    
    // 텍스트가 입력 될때 자동으로 구현해주는 메소드
    
    func textViewDidChange(_ textView: UITextView) {
        
        let contents = textView.text as NSString
        //길이에 대한 if 값을 설정해 준다 ? 로
        let length = ((contents.length > 15) ? 15 : contents.length)
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        self.navigationItem.title = subject
        
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        //경고창에 사용될 뷰 컨트롤러 구성
        let alertV = UIViewController()
        let iconImage = UIImage(named: "warning-icon-60")
        alertV.view = UIImageView(image: iconImage)
        alertV.preferredContentSize = iconImage?.size ?? CGSize.zero
        
        guard self.contents.text.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "메시지를 입력하여 주십시오", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            //콘텐츠 뷰 영역에 alertV를 등록한다.
            alert.setValue(alertV, forKey: "contentViewController")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let data = MemoData()
        
        data.title = self.subject
        data.contents = self.contents.text
        data.image = self.preview.image
        data.regdate = Date()
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.memoList.append(data)
        
        self.dao.insert(data) // 코어 데이터에 메모 데이터를 추가한다.
    
        self.navigationController?.popViewController(animated: true)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
