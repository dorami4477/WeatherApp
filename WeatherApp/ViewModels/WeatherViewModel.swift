//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import Foundation

final class WeatherViewModel{
    var inputViewDidLoadTrigger:Observable<Void?> = Observable(nil)
    var outputWeatherData:Observable<Weather?> = Observable(nil)
    
    init(){
            inputViewDidLoadTrigger.bind { _ in
                self.fetchCurrentWeather()
            }
    }
    
    private func fetchCurrentWeather(){
        NetworkManager.shared.callRequest(api: NetworkAPI.city(id: 1835847), model: Weather.self) { results in
            switch results {
            case .success(let value):
                self.outputWeatherData.value = value
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
