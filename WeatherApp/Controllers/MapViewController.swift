//
//  MapViewController.swift
//  WeatherApp
//
//  Created by 박다현 on 7/12/24.
//

import UIKit
import MapKit


class MapViewController: BaseViewController {

    private var mapView: MKMapView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap(lat: 37.27543611, lon: 127.4432194, title: "test", weather: "Test")
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
    func configureMap(lat:Double, lon:Double, title:String, weather:String) {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.title = title
        annotation.subtitle = weather
        mapView.addAnnotation(annotation)
    }

}
