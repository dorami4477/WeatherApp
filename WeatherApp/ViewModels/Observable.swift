//
//  Observable.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import Foundation

final class Observable<T>{
    var closure:((T) -> Void)?
    
    var value: T{
        didSet{
            closure?(value)
        }
    }
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure : @escaping (T) -> Void){
        closure(value)
        self.closure = closure
    }
}
