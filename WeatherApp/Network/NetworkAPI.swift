//
//  NetworkAPI.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import Foundation
import Alamofire

enum NetworkAPI{
    case city(id:Int)
    case every3hours
    case days
    
    var baseURL:String{
        return "https://api.openweathermap.org/"
    }
    
    var method: HTTPMethod{
        return .get
    }
    
    var endPoint:URL{
        switch self {
        case .city:
            return URL(string:baseURL + "data/2.5/weather")!
        case .every3hours:
            return URL(string:baseURL + "data/2.5/weather")!
        case .days:
            return URL(string:baseURL + "data/2.5/weather")!
        }
    }
    
    var parameter:Parameters{
        switch self {
        case .city(let id):
            return ["id":id, "appid":APIKey.weather]
        case .every3hours:
            return [:]
        case .days:
            return [:]
        }
    }
}
