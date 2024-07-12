//
//  CitySearchViewController.swift
//  WeatherApp
//
//  Created by 박다현 on 7/12/24.
//

import UIKit

class CitySearchViewController: BaseViewController{

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
    }
    
    func configureNavigationItem(){
        let menu = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.title = "City"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = menu
        //서치컨트롤러
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for a city"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    @objc func menuButtonTapped(){}
}

extension CitySearchViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
    }
}
