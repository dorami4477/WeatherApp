//
//  WeatherInfoTVCell.swift
//  WeatherApp
//
//  Created by 박다현 on 7/12/24.
//

import UIKit
import MapKit

final class LocationTVCell: BaseTableViewCell {
    
    private var mapView: MKMapView!
    
    var data:CurrentWithCity?{
        didSet{
            guard let data else { return }
            guard let lat = data.coord["lat"], let lon = data.coord["lon"] else { return }
            configureMap(lat:lat, lon:lon, title: data.name, weather:data.weather.first!.description.capitalized)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureHierarchy() {
        mapView = MKMapView(frame: contentView.bounds)
        contentView.addSubview(mapView)
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
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
