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
        mapView.delegate = self
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

// MARK: - CLLocationManagerDelegate
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
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() //권한 설정 메시지 띄우기
        case .denied:
            configureMap(lat: 37.517412, lon: 126.889131, title: "문래역", subtitle: nil)
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print(#function, status.rawValue)
        }
    }
}

extension MapViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let alert = UIAlertController(title: "날씨 알아보기", message: "해당 위치의 날씨를 알아보시겠습니까?", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .default){ _ in
            guard let viewControllerStack = self.navigationController?.viewControllers else { return }
            for viewController in viewControllerStack {
                if let hereView = viewController as? WeatherViewController {
                    guard let annotation = view.annotation else { return }
                    hereView.viewModel.inputLocationCoord.value = Coord(lon: annotation.coordinate.longitude, lat: annotation.coordinate.latitude)
                    self.navigationController?.popToViewController(hereView, animated: true)
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
