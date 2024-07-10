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
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CVlayout())

    private let viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindData()
    }
    override func configureHierarchy() {
        view.addSubview(cityNameLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(stateLabel)
        view.addSubview(minMaxTemLabel)
        view.addSubview(collectionView)
    }
    override func configureLayout() {
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.centerX.equalToSuperview()
        }
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        minMaxTemLabel.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(minMaxTemLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(150)
        }
        
    }
    override func configureUI() {
        cityNameLabel.font = .systemFont(ofSize: 30)
        temperatureLabel.font = .systemFont(ofSize: 100, weight: .light)
        stateLabel.font = .systemFont(ofSize: 20)
        minMaxTemLabel.font = .systemFont(ofSize: 20)
        //collectionView.backgroundColor = .gray
    }
    
    private func bindData(){
        viewModel.outputCurrentWeather.bind { value in
            guard let value else { return }
            self.cityNameLabel.text = value.name
            self.temperatureLabel.text = String(format: "%.1f", value.main.temp - 273.15) + "°"
            self.stateLabel.text = value.weather.first?.description.capitalized
            self.minMaxTemLabel.text = "최고 : \(String(format: "%.1f", value.main.tempMax - 273.15))° | 최저 : \(String(format: "%.1f", value.main.tempMin - 273.15))°"
        }
        
        viewModel.outputEvery3HoursWeather.bind { _ in
            self.collectionView.reloadData()
        }
    }
    
    private func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: WeatherCell.identifier)
    }
    
    private func CVlayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        let width = ( UIScreen.main.bounds.width - 80 ) / 5
        layout.itemSize = CGSize(width: width, height: width * 2)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return layout
    }

}

extension WeatherViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputEvery3HoursWeather.value?.count ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.identifier, for: indexPath) as? WeatherCell else { return UICollectionViewCell()}
        guard let value = viewModel.outputEvery3HoursWeather.value else { return  UICollectionViewCell()}
        cell.configureData(value[indexPath.row])
        return cell
    }
    
    
}
