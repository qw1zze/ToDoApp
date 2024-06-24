//
//  Date+extensions.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 25.06.2024.
//

import Foundation

extension Date {
    func string() -> String {
        return ISO8601DateFormatter().string(from: self)
    }
    
    static func fromString(string: String?) -> Date? {
        guard let string else {return nil}
        return ISO8601DateFormatter().date(from: string)
    }
 }
