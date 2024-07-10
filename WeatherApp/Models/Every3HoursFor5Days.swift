//
//  Every3HoursFor5Days.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import Foundation

struct Every3HoursFor5Days: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [List]
    let city: City
}

    
struct City: Decodable {
    let id: Int
    let name: String
    let coord: Dictionary<String, Double>
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}


struct List: Decodable {
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Dictionary<String, Double>
    let wind: Dictionary<String, Double>
    let visibility: Int
    let pop: Double
    let rain: Dictionary<String, Double>?
    let sys: Dictionary<String, String>
    let dtTxt: String
    

    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case visibility
        case pop
        case rain
        case sys
        case dtTxt = "dt_txt"
    }
}


struct MainClass: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}




