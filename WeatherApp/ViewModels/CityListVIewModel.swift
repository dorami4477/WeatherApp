//
//  CityListVIewModel.swift
//  WeatherApp
//
//  Created by 박다현 on 7/12/24.
//

import Foundation

final class CityListVIewModel{
    var inputViewDidLoadTrigger:Observable<Void?> = Observable(nil)
    var inputSearchTerm:Observable<String?> = Observable("")
    var outputCityList:[CityList] = []
    var outputFoundCities:Observable<[CityList]> = Observable([])
    
    init(){
        inputViewDidLoadTrigger.bind { _ in
            NetworkManager.shared.fetchCityList {
                self.outputCityList = $0
                self.outputFoundCities.value = self.outputCityList
            }
        }
        inputSearchTerm.bind { value in
            self.searchCity()
        }
    }
    
    private func searchCity(){
        guard let searchTerm = inputSearchTerm.value else { return }
        if !searchTerm.trimmingCharacters(in: .whitespaces).isEmpty{
           let searchResults = outputCityList.filter{ $0.name.lowercased().contains(searchTerm.lowercased()) }
            outputFoundCities.value = searchResults
        }
    }
}
