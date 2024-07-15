//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import Foundation
import Alamofire

enum ErrorCode:Error{
    case invalidRequest
    case overRequest
    case serverError
    case otherErrors
}

final class NetworkManager{
    static let shared = NetworkManager()
    private init(){}
    
    func callRequest<T: Decodable>(api:NetworkAPI, model:T.Type, completionHandler:@escaping (Result<T?, ErrorCode>) ->Void){
        AF.request(api.endPoint,
                   method: api.method,
                   parameters: api.parameter,
                   encoding: URLEncoding(destination: .queryString))
        .validate(statusCode: 200..<505)
        .responseDecodable(of: model) { response in
            switch response.result{
            case .success(let value):
                completionHandler(.success(value))
                
            case .failure:
                let statusCode = response.response?.statusCode
                switch statusCode {
                case 401, 404:
                    completionHandler(.failure(.invalidRequest))
                case 429:
                    completionHandler(.failure(.overRequest))
                case 500, 502, 503, 504:
                    completionHandler(.failure(.serverError))
                default:
                    completionHandler(.failure(.otherErrors))
                }
            }
        }
    }
    
    func fetchCityList(completionHandler:@escaping ([CityList]) -> Void){
        guard let path = Bundle.main.path(forResource: "CityList", ofType: "json") else { return }
        guard let jsonString = try? String(contentsOfFile: path) else { return }
     
        do {
            guard let data = jsonString.data(using: .utf8) else { return }
            let cities = try JSONDecoder().decode([CityList].self, from: data)
            completionHandler(cities)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}
