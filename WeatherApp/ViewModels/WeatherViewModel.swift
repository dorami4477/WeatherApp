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
    var outputEvery3HoursWeather:Observable<[List]> = Observable([])
    var outputWeatherByDate:Observable<[String: (maxTemp: Double, minTemp: Double)]> = Observable([:])
    
    init(){
        inputViewDidLoadTrigger.bind { _ in
            self.fetchCurrentWeather(api:NetworkAPI.current(id: 1835847), model:CurrentWithCity.self)
            self.fetchCurrentWeather(api: NetworkAPI.every3hours(id: 1835847), model: Every3HoursFor5Days.self)
        }
        outputEvery3HoursWeather.bind { _ in
            self.findMinMaxTemp()
        }
    }

    private func fetchCurrentWeather<T:Decodable>(api:NetworkAPI, model:T.Type){
        NetworkManager.shared.callRequest(api: api, model: model) { results in
            switch results {
            case .success(let value):
                if let currentWeather = value as? CurrentWithCity{
                    self.outputCurrentWeather.value = currentWeather
                }else if let every3hours = value as? Every3HoursFor5Days{
                    self.outputEvery3HoursWeather.value = every3hours.list

                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func findMinMaxTemp(){
        var groupedLists:[String: (maxTemp: Double, minTemp: Double)] = [:]

        for list in outputEvery3HoursWeather.value {
            //시간제외
            let dateComponents = list.dtTxt.components(separatedBy: " ")[0]
            
            if let existing = groupedLists[dateComponents] {
                let maxTemp = max(existing.maxTemp, list.main.tempMax)
                let minTemp = min(existing.minTemp, list.main.tempMin)
                groupedLists[dateComponents] = (maxTemp, minTemp)
            } else {
                groupedLists[dateComponents] = (list.main.tempMax, list.main.tempMin)
            }
        }
        outputWeatherByDate.value = groupedLists
    }
}
