//
//  MapKitViewController.swift
//  Chapter03-Alert
//
//  Created by Samuel K on 2017. 11. 14..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //맵 킷 관련된 내용을 별도의 뷰 컨트롤러에 선언하여 줌으로써, 기능의 분별을 두도록 한다.
        
        let mapkitView = MKMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        //핀 값을 설정하여 준다.
        let pos = CLLocationCoordinate2D(latitude: 37.514322, longitude: 126.894623)
        //지도상에 보여줄 축척을 설정하여 준다.
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        //지도 영역을 설정하여 준다.
        let region = MKCoordinateRegion(center: pos, span: span)
        //지도를 뷰에 표시한다.
        mapkitView.region = region
        mapkitView.regionThatFits(region)
        
        //현재 위치를 핀으로 표시한다.
        let point = MKPointAnnotation()
        point.coordinate = pos
        mapkitView.addAnnotation(point)
        
        self.view = mapkitView
        self.preferredContentSize.height = 200
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
