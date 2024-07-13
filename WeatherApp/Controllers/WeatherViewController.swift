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

    let viewModel = WeatherViewModel()
    
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
        //viewModel.inputCityID.value = 1835847

        viewModel.outputCurrentWeather.bind { value in
            guard let value else { return }
            self.cityNameLabel.text = value.name
            self.temperatureLabel.text = value.main.tempString
            self.stateLabel.text = value.weather.first?.description.capitalized
            self.minMaxTemLabel.text = value.main.tempMaxString + " | " + value.main.tempMinString
        }
        
        viewModel.outputEvery3HoursWeather.bind { _ in
            guard let currentCell = self.tableView.cellForRow(at: [0,0]) as? HourWeatherTVCell else { return }
            self.viewModel.findMinMaxTemp()
            currentCell.collectionView.reloadData()
        }
        viewModel.outputWeatherByDate.bind{ _ in
            self.tableView.reloadData()
        }
    }
    
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HourWeatherTVCell.self, forCellReuseIdentifier: HourWeatherTVCell.identifier)
        tableView.register(DayWeatherTVCell.self, forCellReuseIdentifier: DayWeatherTVCell.identifier)
        tableView.register(WeatherInfoTVCell.self, forCellReuseIdentifier: WeatherInfoTVCell.identifier)
    }
    

    deinit {
        print("weather deinit")
    }
}

// MARK: - TableViewDalegate
extension WeatherViewController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 150
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "3시간 간격의 일기예보"
        default:
            return "5일간의 일기예보"
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        default:
            return viewModel.outputWeatherByDate.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourWeatherTVCell.identifier, for: indexPath) as? HourWeatherTVCell  else { return UITableViewCell()}
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.register(HourWeatherCVCell.self, forCellWithReuseIdentifier: HourWeatherCVCell.identifier)
            return cell
        }else if indexPath.section == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DayWeatherTVCell.identifier, for: indexPath) as? DayWeatherTVCell  else { return UITableViewCell()}
            cell.configureData(data: viewModel.outputWeatherByDate.value[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
}
    
// MARK: - CollectionViewDelegate
extension WeatherViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputEvery3HoursWeather.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourWeatherCVCell.identifier, for: indexPath) as? HourWeatherCVCell else { return UICollectionViewCell()}
        let value = viewModel.outputEvery3HoursWeather.value
        cell.configureData(value[indexPath.row])
        return cell
    }
    
}
