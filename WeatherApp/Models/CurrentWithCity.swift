//
//  Weather.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import Foundation

struct CurrentWithCity:Decodable {
    let coord: Dictionary<String, Double>
    let weather: [Summary]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Dictionary<String, Double>
    let dt: Int
    let sys: Sys?
    let timezone, id: Int
    let name: String
    let cod: Int
    
}

struct Summary: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int
    let tempString, tempMinString, tempMaxString:String

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(Double.self, forKey: .temp)
        self.feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        self.tempMin = try container.decode(Double.self, forKey: .tempMin)
        self.tempMax = try container.decode(Double.self, forKey: .tempMax)
        self.pressure = try container.decode(Int.self, forKey: .pressure)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.seaLevel = try container.decode(Int.self, forKey: .seaLevel)
        self.grndLevel = try container.decode(Int.self, forKey: .grndLevel)
        self.tempString = String(format: "%.1f", self.temp - 273.15) + "°"
        self.tempMinString = "최저 : " + String(format: "%.1f", self.tempMin - 273.15) + "°"
        self.tempMaxString = "최고 : " + String(format: "%.1f", self.tempMax - 273.15) + "°"
    }
}

// MARK: - Sys
struct Sys: Decodable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise, sunset: Int?
}


// MARK: - Wind
struct Wind: Decodable {
    let speed: Double
    let deg: Double
    let gust:Double?
}


