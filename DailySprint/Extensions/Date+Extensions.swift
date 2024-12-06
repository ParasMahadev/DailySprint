//
//  Date+Extensions.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//

import Foundation

extension Date {
    
    // MARK: - Check if Date is Today
    // Returns true if the date is today's date
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
    
    // MARK: - Check if Date is Tomorrow
    // Returns true if the date is tomorrow's date
    var isTomorrow: Bool {
        let calendar = Calendar.current
        return calendar.isDateInTomorrow(self)
    }
    
    // MARK: - Extract Date Components
    // Returns the components (year, month, day, hour, minute) of the date
    var dateComponents: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
    }
}
