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
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "sky")
        backgroundImage.alpha = 0.3
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func bindData(){
        //viewModel.inputCityID.value = 1835847

        viewModel.outputCurrentWeather.bind { value in
            guard let value else { return }
            self.cityNameLabel.text = value.name
            self.temperatureLabel.text = value.main.tempString
            self.stateLabel.text = value.weather.first?.description.capitalized
            self.minMaxTemLabel.text = value.main.tempMaxString + " | " + value.main.tempMinString
            self.viewModel.getAdditionalWeatherInfo()
            self.tableView.reloadData()
        }
        viewModel.outputAdditionalInfo.bind{ _ in
            guard let currentCell = self.tableView.cellForRow(at: [3,0]) as? WeatherInfoTVCell else { return }
            currentCell.collectionView.reloadData()
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
        tableView.register(LocationTVCell.self, forCellReuseIdentifier: LocationTVCell.identifier)
        tableView.register(WeatherInfoTVCell.self, forCellReuseIdentifier: WeatherInfoTVCell.identifier)
        tableView.backgroundColor = .clear
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
        case 2:
            return 230
        case 3:
            return  UIScreen.main.bounds.width
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "3시간 간격의 일기예보"
        case 1:
            return "5일간의 일기예보"
        case 2:
            return "위치"
        default:
            return ""
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 1:
            return viewModel.outputWeatherByDate.value.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourWeatherTVCell.identifier, for: indexPath) as? HourWeatherTVCell  else { return UITableViewCell()}
            cell.backgroundColor = UIColor.clear
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.register(HourWeatherCVCell.self, forCellWithReuseIdentifier: HourWeatherCVCell.identifier)
            cell.collectionView.tag = 0
            return cell
        }else if indexPath.section == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DayWeatherTVCell.identifier, for: indexPath) as? DayWeatherTVCell  else { return UITableViewCell()}
            cell.backgroundColor = UIColor.clear
            cell.configureData(data: viewModel.outputWeatherByDate.value[indexPath.row])
            return cell
        }else if indexPath.section == 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTVCell.identifier, for: indexPath) as? LocationTVCell  else { return UITableViewCell()}
            cell.backgroundColor = UIColor.clear
            cell.data = viewModel.outputCurrentWeather.value
            return cell
        }else if indexPath.section == 3{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTVCell.identifier, for: indexPath) as? WeatherInfoTVCell  else { return UITableViewCell()}
            cell.backgroundColor = UIColor.clear
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.register(WeatherInfoCVCell.self, forCellWithReuseIdentifier: WeatherInfoCVCell.identifier)
            cell.collectionView.tag = 1
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
    
// MARK: - CollectionViewDelegate
extension WeatherViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return viewModel.outputEvery3HoursWeather.value.count
        }else{
            return viewModel.outputAdditionalInfo.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourWeatherCVCell.identifier, for: indexPath) as? HourWeatherCVCell else { return UICollectionViewCell()}
            let value = viewModel.outputEvery3HoursWeather.value
            cell.configureData(value[indexPath.row])
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherInfoCVCell.identifier, for: indexPath) as? WeatherInfoCVCell else { return UICollectionViewCell()}
            cell.data = viewModel.outputAdditionalInfo.value[indexPath.row]
            return cell
        }

    }
    
}

    
