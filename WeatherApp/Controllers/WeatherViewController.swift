//
//  ViewController.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import UIKit
import SnapKit

final class WeatherViewController: BaseViewController {
    
    private let cityNameLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let stateLabel = UILabel()
    private let minMaxTemLabel = UILabel()

    private let viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    override func configureHierarchy() {
        view.addSubview(cityNameLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(stateLabel)
        view.addSubview(minMaxTemLabel)
    }
    override func configureLayout() {
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
        }
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        minMaxTemLabel.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
    }
    override func configureUI() {
        cityNameLabel.font = .systemFont(ofSize: 30)
        temperatureLabel.font = .systemFont(ofSize: 100)
        stateLabel.font = .systemFont(ofSize: 20)
        minMaxTemLabel.font = .systemFont(ofSize: 20)
    }
    private func bindData(){
        viewModel.outputCurrentWeather.bind { value in
            guard let value else { return }
            self.cityNameLabel.text = value.name
            self.temperatureLabel.text = "\(round(value.main.temp - 273.15))°"
            self.stateLabel.text = value.weather.first?.description.capitalized
            self.minMaxTemLabel.text = "최고 : \(round(value.main.tempMax - 273.15))° | 최저 : \(round(value.main.tempMin - 273.15))°"
        }
        
        viewModel.outputEvery3HoursWeather.bind { value in
            //네트워크 성공
            print(value)
        }
    }


}

