//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import UIKit
import Kingfisher

final class HourWeatherCVCell: UICollectionViewCell {
    private let timeLabel = UILabel()
    private let iconImageView = UIImageView()
    private let temperatureLebel = UILabel()
    
    
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
        contentView.backgroundColor = .clear
    }
    
    func configureData(_ data:List){
        timeLabel.text = data.timeString
        temperatureLebel.text = data.main.tempString
        guard let icon = data.weather.first?.icon else { return }
        let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        iconImageView.kf.setImage(with: url)
    }
    

}
