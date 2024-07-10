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
    private let tableView = UITableView()

    private let viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindData()
    }
    override func configureHierarchy() {
        view.addSubview(cityNameLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(stateLabel)
        view.addSubview(minMaxTemLabel)
        view.addSubview(tableView)
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
        tableView.snp.makeConstraints { make in
            make.top.equalTo(minMaxTemLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    override func configureUI() {
        cityNameLabel.font = .systemFont(ofSize: 30)
        temperatureLabel.font = .systemFont(ofSize: 100, weight: .light)
        stateLabel.font = .systemFont(ofSize: 20)
        minMaxTemLabel.font = .systemFont(ofSize: 20)
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
            guard let currentCell = self.tableView.cellForRow(at: [0,0]) as? WeatherTableViewCell else { return }
            currentCell.collectionView.reloadData()
        }
    }
    
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.rowHeight = 150
    }
    


}

// MARK: - TableViewDalegate
extension WeatherViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "3시간 간격의 일기예보"
        default:
            return ""
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell  else { return UITableViewCell()}
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: WeatherCell.identifier)
            return cell
        }
        return UITableViewCell()
    }
    
    
}
    
// MARK: - CollectionViewDelegate
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
