//
//  DateFormatter.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import Foundation

final class DateFormatterManager{
    static let shared = DateFormatterManager()
    private init(){}
    
    static let formatter = DateFormatter()
    
    func stringConvertToDateTime(date:String, newFormat:String) -> String {
        let stringFormat = "yyyy-MM-dd HH:mm:ss"
        DateFormatterManager.formatter.dateFormat = stringFormat
        DateFormatterManager.formatter.locale = Locale(identifier: "ko")
        guard let tempDate = DateFormatterManager.formatter.date(from: date) else {
            return ""
        }
        DateFormatterManager.formatter.dateFormat = newFormat
        
        return DateFormatterManager.formatter.string(from: tempDate)
    }
    
    func dateCompare(fromDate: String, targetDate:String) -> Bool {
        DateFormatterManager.formatter.dateFormat = "yyyy-MM-dd"
        if let targetDate: Date = DateFormatterManager.formatter.date(from: targetDate),
           let fromDate: Date = DateFormatterManager.formatter.date(from: fromDate) {
            switch targetDate.compare(fromDate) {
            case .orderedSame: return true
            case .orderedDescending: return false
            case .orderedAscending: return false
            }
        }
        return false
    }
    

}
