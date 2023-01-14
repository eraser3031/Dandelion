//
//  Date+Extension.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/02.
//

import Foundation

extension DateFormatter {
    
    static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        return formatter
    }()
    
}

extension Date {
    
    var toDay: Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? self
    }
    
    var year: Int {
        let year = Calendar.current.component(.year, from: self)
        return year
    }
    
    var month: Int {
        let month = Calendar.current.component(.month, from: self)
        return month
    }
    
    var day: Int {
        let day = Calendar.current.component(.day, from: self)
        return day
    }
    
    var minute: Int {
        let minute = Calendar.current.component(.minute, from: self)
        return minute
    }
}
