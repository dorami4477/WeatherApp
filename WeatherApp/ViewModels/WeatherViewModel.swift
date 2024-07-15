//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import Foundation

final class WeatherViewModel{
    //var inputCityID = Observable(1835847)
    var inputLocationCoord:Observable<Coord> = Observable(Coord(lon: 127.049696, lat: 37.654165))
    var inputScrollY:Observable<Double> = Observable(0.0)
   
    var outputCurrentWeather:Observable<CurrentWithCity?> = Observable(nil)
    var outputEvery3HoursWeather:Observable<[List]> = Observable([])
    var outputWeatherByDate:Observable<[WeatherFor5Ddays]> = Observable([])
    var outputAdditionalInfo:Observable<[AdditionalWeatherInfo]> = Observable([])
    
    var outputTopSpacing:Observable<Double> = Observable(0.0)
    var outputlowerThanTop:Observable<Bool> = Observable(false)
    var outputStopExpandHeaderHeight:Observable<Bool> = Observable(false)
    
    init(){
        inputLocationCoord.bind { value in
            self.fetchCurrentWeather(api:NetworkAPI.current(lat: self.inputLocationCoord.value.lat, lon: self.inputLocationCoord.value.lon), model:CurrentWithCity.self)
            self.fetchCurrentWeather(api: NetworkAPI.every3hours(lat: self.inputLocationCoord.value.lat, lon: self.inputLocationCoord.value.lon), model: Every3HoursFor5Days.self)
        }
        inputScrollY.bind { value in
            print(value)
            self.scrollAction(Y: value)
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
    
    func getAdditionalWeatherInfo(){
        guard let outputValue = outputCurrentWeather.value else {return}
        let weatherInfo:[AdditionalWeatherInfo] = [
            AdditionalWeatherInfo(title: "바람 속도", Info: String(format: "%.1f", outputValue.wind.speed) + "m/s", detail: "강풍: " + String(format: "%.1f", outputValue.wind.gust ?? "") + "m/s"),
            AdditionalWeatherInfo(title: "구름", Info: outputValue.clouds["all"]!.formatted() + "%", detail: nil),
            AdditionalWeatherInfo(title: "기압", Info: outputValue.main.pressure.formatted()  + "hpa", detail: nil),
            AdditionalWeatherInfo(title: "습도", Info: outputValue.main.humidity.formatted()  + "%", detail:nil)
        ]
        outputAdditionalInfo.value = weatherInfo
    }
    
    
    func scrollAction(Y:Double){
        outputTopSpacing.value = abs(Y) + 42
        outputlowerThanTop.value = Y - 42  < 0
        outputStopExpandHeaderHeight.value = Y - 42 > -Metric.startTableView
    }
  
    private enum Metric {
        static let startTableView = 120.0
        static let tableInsetTop = 100.0
    }

}







