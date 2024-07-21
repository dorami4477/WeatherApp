//
//  WeatherFor5Ddays.swift
//  WeatherApp
//
//  Created by 박다현 on 7/11/24.
//

import Foundation

struct WeatherFor5Ddays {
    var date:String
    let icon:String
    let minTemp:Double
    let maxTemp:Double
    
    var maxTempString:String{
        return "최고 " + String(format: "%.1f", maxTemp - 273.15) + "°"
    }
    
    var minTempString:String{
        return "최저 " + String(format: "%.1f", minTemp - 273.15) + "°"
    }
}
