//
//  CitySearchViewController.swift
//  WeatherApp
//
//  Created by 박다현 on 7/12/24.
//

import UIKit

final class CitySearchViewController: BaseViewController{

    private let tableView = UITableView()
    let viewModel = CityListVIewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureTableView()
        bindData()
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindData(){
        //viewModel.inputViewDidLoadTrigger.value = ()
        viewModel.outputFoundCities.bind { _ in
            self.tableView.reloadData()
        }
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityListTVCell.self, forCellReuseIdentifier: CityListTVCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func configureNavigationItem(){
        let menu = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(menuButtonTapped))
        menu.tintColor = .white
        navigationItem.title = "City"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = menu
        //서치컨트롤러
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for a city"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.isToolbarHidden = true
    }

    @objc func menuButtonTapped(){}
}
extension CitySearchViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputFoundCities.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityListTVCell.identifier, for: indexPath) as? CityListTVCell else { return UITableViewCell() }
        cell.data = viewModel.outputFoundCities.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewControllerStack = self.navigationController?.viewControllers else { return }
        for viewController in viewControllerStack {
            if let hereView = viewController as? WeatherViewController {
                hereView.viewModel.inputCityID.value = viewModel.outputFoundCities.value[indexPath.row].id
                self.navigationController?.popToViewController(hereView, animated: true)
            }
        }
    }
}

extension CitySearchViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.inputSearchTerm.value = searchController.searchBar.text
    }
}
