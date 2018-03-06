//
//  TutorialMasterVC.swift
//  MyMemory
//
//  Created by Samuel K on 2018. 3. 6..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class TutorialMasterVC: UIViewController, UIPageViewControllerDataSource {
    
    //페이지 뷰 컨트롤러의 인스턴스를 참조할 변수 설정(맴버 변수)
    var pageVC: UIPageViewController!
    
    //컨텐츠 뷰 컨트롤러에 들어갈 타이틀과 이미지
    var contentTitles = ["STEP 1", "STEP 2", "STEP 3", "STEP 4"]
    var contentImages = ["page0", "page1", "page2", "page3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makePagingView()
        
    }
    
    func makePagingView() {
        
        //1. 페이지뷰 컨트롤러 객체 생성
        self.pageVC = self.instanceTutorialVC(name: "PageVC") as! UIPageViewController
        self.pageVC.dataSource = self
        
        //2. 페이비 뷰 컨트롤러의 기본 페이지 지정
        let startContentVC = self.getContentVC(atIndex: 0)! // 최초 노출된 콘텐츠 뷰 컨트롤러
        self.pageVC.setViewControllers([startContentVC], direction: .forward, animated: true)
        
        //3. 페이지 뷰 컨트롤러 출력 영역 지정
        self.pageVC.view.frame.origin = CGPoint(x: 0, y: 0)
        self.pageVC.view.frame.size.width = self.view.frame.width
        self.pageVC.view.frame.size.height = self.view.frame.height - 50
        
        //4. 페이지 뷰 컨트롤러를 마스터 뷰 컨트롤러 자식 뷰 컨트롤러로 지정
        self.addChildViewController(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParentViewController: self)
        
    }
    
    @IBAction func close(_ sender: Any) {
        
        //처음 시작할 때, Bool값을 넣어줌으로써 다음부턴 실행되지 않게 한다.
        let ud = UserDefaults.standard
        ud.set(true, forKey: UserInfoKey.tutorial)
        ud.synchronize()
        
        //확인이 되면 해당 화면을 내려준다.
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    //뷰컨트롤러를 반환하는 메서드를 만든다.
    func getContentVC(atIndex idx:Int) -> UIViewController? {
        //인덱스가 배열크기에 넘어가지 않게 한다.
        guard self.contentTitles.count >= idx && self.contentTitles.count > 0 else { return nil }
        
        //ContentsVC라는 스토리보드ID를 가진 뷰컨트롤러의 인스턴스를 생성하고 캐스팅한다.
        guard let cvc = self.instanceTutorialVC(name: "ContentsVC") as? TutorialContentsVC else { return nil }
        
        cvc.titleText = self.contentTitles[idx]
        cvc.imageFile = self.contentImages[idx]
        cvc.pageIndex = idx
        
        return cvc
        
    }
    
    //현재보다 앞에 올 콘텐츠 뷰 객체
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //현재 인덱스 설정
        guard var index = (viewController as! TutorialContentsVC).pageIndex else { return nil }
        
        //현재 인덱스가 맨앞이라면 nil을 반환하고 종료
        guard index > 0 else { return nil }
        index -= 1 // 현재의 인덱스에서 하나 뺌
        
        return self.getContentVC(atIndex: index)
        
    }
    
    //현재보다 뒤에 올 콘텐츠 뷰 객체
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //현재 인덱스 설정
        guard var index = (viewController as! TutorialContentsVC).pageIndex else { return nil }
        index += 1
        //인덱스는 항상 배열 데이터의 크기보다 작아야 한다.
        guard index < self.contentTitles.count else { return nil }
        
        return self.getContentVC(atIndex: index)
    }
    
    //인디케이터 설정
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.contentTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    

}
