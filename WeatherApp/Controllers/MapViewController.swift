//
//  MapViewController.swift
//  WeatherApp
//
//  Created by 박다현 on 7/12/24.
//

import UIKit
import MapKit
import CoreLocation

final class MapViewController: BaseViewController {

    private var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    override func configureHierarchy() {
        mapView = MKMapView(frame: view.bounds)
        view.addSubview(mapView)
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureUI() {
        navigationController?.isToolbarHidden = true
    }
    
    private func configureMap(lat:Double, lon:Double, title:String, subtitle:String?) {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }

}


extension MapViewController:CLLocationManagerDelegate{
    //- 사용자 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate{
            configureMap(lat: coordinate.latitude, lon: coordinate.longitude, title: "내위치", subtitle: nil)
        }
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "iOS14+")
        checkDeviceLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function, "iOS14-")
    }
    
    func checkDeviceLocationAuthorization(){
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                self.checkCurrentLocationAuthorization()
            }else{
                print("해당 아이폰의 위치 서비스가 꺼져있습니다.")
            }
        }

    }
    
    func checkCurrentLocationAuthorization(){
        var status:CLAuthorizationStatus
        
        if #available(iOS 14.0, *){
            status = locationManager.authorizationStatus
        }else{
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .notDetermined:
            print(status)
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() //권한 설정 메시지 띄우기
        case .denied:
            print(status)
            print("iOS 설정 창으로 이동하라는 얼럿을 띄워주기")
        case .authorizedWhenInUse:
            print(status)
            locationManager.startUpdatingLocation()
        default:
            print(status)
        }
    }
}
