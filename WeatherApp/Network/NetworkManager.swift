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
    case invalidAuth
    case invalidURL
    case overRequest
    case serverError
}

final class NetworkManager{
    static let shared = NetworkManager()
    private init(){}
    
    func callRequest<T: Decodable>(api:NetworkAPI, model:T.Type, completionHandler:@escaping (Result<T?, ErrorCode>) ->Void){
        AF.request(api.endPoint,
                   method: api.method,
                   parameters: api.parameter,
                   encoding: URLEncoding(destination: .queryString))
        .validate(statusCode: 200..<500)
        .responseDecodable(of: model) { response in
            switch response.result{
            case .success(let value):
                completionHandler(.success(value))
                
            case .failure(let error):
                print(error)
                completionHandler(.failure(.invalidRequest))
            }
        }
    }
}
