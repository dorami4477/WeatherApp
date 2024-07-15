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
    let snow: Dictionary<String, Double>?
    let sys: Dictionary<String, String>
    let dtTxt: String
    let timeString :String

    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case visibility
        case pop
        case rain
        case snow
        case sys
        case dtTxt = "dt_txt"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decode(Int.self, forKey: .dt)
        self.main = try container.decode(MainClass.self, forKey: .main)
        self.weather = try container.decode([Weather].self, forKey: .weather)
        self.clouds = try container.decode([String : Double].self, forKey: .clouds)
        self.wind = try container.decode([String : Double].self, forKey: .wind)
        self.visibility = try container.decode(Int.self, forKey: .visibility)
        self.pop = try container.decode(Double.self, forKey: .pop)
        self.rain = try container.decodeIfPresent([String : Double].self, forKey: .rain)
        self.snow = try container.decodeIfPresent([String : Double].self, forKey: .snow)
        self.sys = try container.decode([String : String].self, forKey: .sys)
        self.dtTxt = try container.decode(String.self, forKey: .dtTxt)
        self.timeString = DateFormatterManager.shared.stringConvertToDateTime(date:self.dtTxt, newFormat: "HH") + "시"
    }
}


struct MainClass: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double
    let tempString: String
    
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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(Double.self, forKey: .temp)
        self.feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        self.tempMin = try container.decode(Double.self, forKey: .tempMin)
        self.tempMax = try container.decode(Double.self, forKey: .tempMax)
        self.pressure = try container.decode(Int.self, forKey: .pressure)
        self.seaLevel = try container.decode(Int.self, forKey: .seaLevel)
        self.grndLevel = try container.decode(Int.self, forKey: .grndLevel)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.tempKf = try container.decode(Double.self, forKey: .tempKf)
        self.tempString = String(format: "%.1f", self.temp - 273.15) + "°"
    }
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}




