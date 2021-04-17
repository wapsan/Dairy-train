//
//  Date+Ex.swift
//  Dairy Training
//
//  Created by cogniteq on 19.03.21.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import Foundation

extension Date {
   static  func weekPeriod(using calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return Date() + TimeInterval(3600 * 24 * 7)
    }
    
    static func mounthPeriod(using calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
         return Date() + TimeInterval(3600 * 24 * 7 * 4)
     }
    
    
    static let now = Date()
}
