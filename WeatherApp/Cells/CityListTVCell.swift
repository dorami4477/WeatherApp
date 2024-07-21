//
//  CityListTVCell.swift
//  WeatherApp
//
//  Created by 박다현 on 7/12/24.
//

import UIKit

final class CityListTVCell: BaseTableViewCell {
    private let iconLabel = UILabel()
    private let nameLabel = UILabel()
    private let countryLabel = UILabel()
    
    var data:CityList = CityList(id: 0, name: "", state: "", country: "", coord: Coord(lon: 0, lat: 0)){
        didSet{
            configureData()
        }
    }
    
    override func configureHierarchy() {
        addSubview(iconLabel)
        addSubview(nameLabel)
        addSubview(countryLabel)
    }
    
    override func configureLayout() {
        iconLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(iconLabel.snp.trailing).offset(10)
        }
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(iconLabel.snp.trailing).offset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        iconLabel.text = "#"
        iconLabel.font = .systemFont(ofSize: 20)
        nameLabel.font = .systemFont(ofSize: 20)
        countryLabel.textColor = .gray
    }

    private func configureData(){
        nameLabel.text = data.name
        countryLabel.text = data.country
    }
}
