//
//  DayWeatherTViCell.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import UIKit

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
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(30)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(dayLabel.snp.trailing).offset(5)
        }
        minTempLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(iconImageView.snp.trailing).offset(5)
        }
        maxTempLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(minTempLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(30)
        }
    }
    private func configureUI(){
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
