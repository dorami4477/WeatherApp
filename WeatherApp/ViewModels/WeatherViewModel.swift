//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import Foundation

final class WeatherViewModel{
    var inputViewDidLoadTrigger:Observable<Void?> = Observable(nil)
    var outputCurrentWeather:Observable<CurrentWithCity?> = Observable(nil)
    var outputEvery3HoursWeather:Observable<Every3HoursFor5Days?> = Observable(nil)
    
    init(){
            inputViewDidLoadTrigger.bind { _ in
                self.fetchCurrentWeather(api:NetworkAPI.city(id: 1835847), model:CurrentWithCity.self)
                self.fetchCurrentWeather(api: NetworkAPI.every3hours(lat: 37.498061, lon: 127.028759), model: Every3HoursFor5Days.self)
            }
    }

    private func fetchCurrentWeather<T:Decodable>(api:NetworkAPI, model:T.Type){
        NetworkManager.shared.callRequest(api: api, model: model) { results in
            switch results {
            case .success(let value):
                if let currentWeather = value as? CurrentWithCity{
                    self.outputCurrentWeather.value = currentWeather
                }else if let every3hours = value as? Every3HoursFor5Days{
                    self.outputEvery3HoursWeather.value = every3hours
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
