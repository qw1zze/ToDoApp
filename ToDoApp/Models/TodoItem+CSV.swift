//
//  TodoItem+CSV.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 25.06.2024.
//

import Foundation

extension TodoItem {
    static func parse(csv: String) -> TodoItem? {
        var properties = [String]()
        var property = ""
        var inProperty = false
        
        for char in csv {
            if char == "," {
                if inProperty {
                    property.append(char)
                } else {
                    properties.append(property)
                    property = ""
                }
            } else if char == "\"" {
                inProperty.toggle()
            } else {
                property.append(char)
            }
        }
        properties.append(property)
        
        guard properties.count == 7 else {
            return nil
        }
        
        var id = properties[0]
        let text = properties[1]
        let priority = properties[2]
        let deadline = properties[3]
        let completed = properties[4]
        let created = properties[5]
        let changed = properties[6]
        
        guard let priority = Priority(rawValue: priority),  let completed = Bool(completed), let created = Date.fromString(string: created) else {
            return nil
        }
        
        return TodoItem(id: id,
                        text: text,
                        priority: priority,
                        deadline: Date.fromString(string: deadline),
                        completed: completed,
                        created: created,
                        changed: Date.fromString(string: changed))
    }
    
    var csv: String {
        return "\(id),\(text),\(priority.rawValue),\(deadline?.string() ?? ""),\(completed),\(created.string())\(changed?.string() ?? "")"
    }
}
