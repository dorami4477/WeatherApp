//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import UIKit
import Kingfisher

class WeatherCell: UICollectionViewCell {
    let timeLabel = UILabel()
    let iconImageView = UIImageView()
    let temperatureLebel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureHierarchy(){
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(temperatureLebel)
    }
    private func configureLayout(){
        timeLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
        }
        temperatureLebel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    private func configureUI(){
        timeLabel.textAlignment = .center
        temperatureLebel.textAlignment = .center
        iconImageView.contentMode = .scaleAspectFit
    }
    
    func configureData(_ data:List){
        timeLabel.text = stringConvertToDateTime(date:data.dtTxt) + "시"
        temperatureLebel.text = String(format: "%.1f", data.main.temp - 273.15) + "°"
        guard let icon = data.weather.first?.icon else { return }
        let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        iconImageView.kf.setImage(with: url)
    }
    
    private func stringConvertToDateTime(date:String) -> String {
        let stringFormat = "yyyy-MM-dd HH:mm:ss"
        let formatter = DateFormatter()
        formatter.dateFormat = stringFormat
        formatter.locale = Locale(identifier: "ko")
        guard let tempDate = formatter.date(from: date) else {
            return ""
        }
        formatter.dateFormat = "HH"
        
        return formatter.string(from: tempDate)
    }
}
