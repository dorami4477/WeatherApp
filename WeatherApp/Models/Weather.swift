//
//  Weather.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import Foundation

struct Weather:Decodable{
    let coord: Dictionary<String, Double>
    let weather: [Summary]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Dictionary<String, Double>
    let dt: Int
    let sys: Sys
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

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Decodable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}


// MARK: - Wind
struct Wind: Decodable {
    let speed: Double
    let deg: Double
}


