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
    
    @IBOutlet var contents: UITextView!
    @IBOutlet var preview: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contents.delegate = self
        
        
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
        
        guard self.contents.text.isEmpty == false else {
            
            let alert = UIAlertController(title: nil, message: "메시지를 입력하여 주십시오", preferredStyle: .alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let data = MemoData()
        
        data.title = self.subject
        data.contents = self.contents.text
        data.image = self.preview.image
        data.redate = Date()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memoList.append(data)
    
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
