//
//  DayWeatherTViCell.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import UIKit
import Kingfisher

final class DayWeatherTVCell: UITableViewCell {
    let dayLabel = UILabel()
    let iconImageView = UIImageView()
    let minTempLabel = UILabel()
    let maxTempLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    private func configureHierarchy(){
        addSubview(dayLabel)
        addSubview(iconImageView)
        addSubview(minTempLabel)
        addSubview(maxTempLabel)
    }
    private func configureLayout(){
        dayLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().offset(30)
        }
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
            make.leading.equalTo(dayLabel.snp.trailing).offset(28)
        }
        minTempLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
        }
        maxTempLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalTo(minTempLabel.snp.trailing).offset(28)
            make.trailing.equalToSuperview().inset(30)
        }
    }
    private func configureUI(){
        dayLabel.font = .systemFont(ofSize: 20)
        minTempLabel.font = .systemFont(ofSize: 20)
        maxTempLabel.font = .systemFont(ofSize: 20)
        
        minTempLabel.textColor = .lightGray
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(data:WeatherFor5Ddays){
        dayLabel.text = data.date
        let url = URL(string: "https://openweathermap.org/img/wn/\(data.icon)@2x.png")
        iconImageView.kf.setImage(with: url)
        maxTempLabel.text = data.maxTempString
        minTempLabel.text = data.minTempString
    }
}
