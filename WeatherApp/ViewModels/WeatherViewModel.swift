//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import Foundation

final class WeatherViewModel{
    var inputViewDidLoadTrigger:Observable<Void?> = Observable(nil)
    var inputCityID = Observable(1835847)
    
    var outputCurrentWeather:Observable<CurrentWithCity?> = Observable(nil)
    var outputEvery3HoursWeather:Observable<[List]> = Observable([])
    var outputWeatherByDate:Observable<[WeatherFor5Ddays]> = Observable([])
    
    
    init(){
      /* inputViewDidLoadTrigger.bind { _ in
            self.fetchCurrentWeather(api:NetworkAPI.current(id: self.inputCityID.value), model:CurrentWithCity.self)
            self.fetchCurrentWeather(api: NetworkAPI.every3hours(id: self.inputCityID.value), model: Every3HoursFor5Days.self)
        }*/
        outputEvery3HoursWeather.bind { _ in
            self.findMinMaxTemp()
        }
        inputCityID.bind { value in
            print(value)
            self.fetchCurrentWeather(api:NetworkAPI.current(id: self.inputCityID.value), model:CurrentWithCity.self)
            self.fetchCurrentWeather(api: NetworkAPI.every3hours(id: self.inputCityID.value), model: Every3HoursFor5Days.self)
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
        var weatherData: [WeatherFor5Ddays] = []

        for list in outputEvery3HoursWeather.value {
            let dateComponents = DateFormatterManager.shared.stringConvertToDateTime(date: list.dtTxt, newFormat: "EEEEEE")

            if let existingIndex = weatherData.firstIndex(where: { $0.date == dateComponents }) {
                let maxTemp = max(weatherData[existingIndex].maxTemp, list.main.tempMax)
                let minTemp = min(weatherData[existingIndex].minTemp, list.main.tempMin)
                weatherData[existingIndex] = WeatherFor5Ddays(date: dateComponents, icon:list.weather[0].icon, minTemp: minTemp, maxTemp: maxTemp)
            } else {
                let newWeatherData = WeatherFor5Ddays(date: dateComponents, icon:list.weather[0].icon,  minTemp: list.main.tempMin, maxTemp: list.main.tempMax)
                weatherData.append(newWeatherData)
            }
        }

        outputWeatherByDate.value = weatherData

    }
  
}





