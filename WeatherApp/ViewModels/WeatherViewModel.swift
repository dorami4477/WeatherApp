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
    var outputEvery3HoursWeather:Observable<[List]?> = Observable(nil)
    
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
                    self.outputEvery3HoursWeather.value = every3hours.list

                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    /*
    func configureData(_ data:List){
        timeLabel.text = data.dtTxt
        temperatureLebel.text = "\(data.main.temp)"
        guard let icon = data.weather.first?.icon else { return }
        let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        iconImageView.kf.setImage(with: url)
    }
    
    private func stringConvertToDateTime(date:String) -> String {
        let stringFormat = "yyyy-MM-dd HH:mm"
        let formatter = DateFormatter()
        formatter.dateFormat = stringFormat
        formatter.locale = Locale(identifier: "ko")
        guard let tempDate = formatter.date(from: date) else {
            return ""
        }
        formatter.dateFormat = "HH"
        
        return formatter.string(from: tempDate)
    }*/
}
