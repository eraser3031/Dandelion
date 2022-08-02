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
