//
//  TodoItem+JSON.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 25.06.2024.
//

import Foundation

extension TodoItem {
    init?(dict: [String: Any]) {
        let id = dict[TodoCodingKeys.id.rawValue] as? String
        let text = dict[TodoCodingKeys.text.rawValue] as? String
        let priority = dict[TodoCodingKeys.priority.rawValue] as? Priority ?? .neutral
        let deadline = Date.fromString(string: dict[TodoCodingKeys.deadline.rawValue] as? String)
        let completed = dict[TodoCodingKeys.completed.rawValue] as? Bool
        let created = Date.fromString(string: dict[TodoCodingKeys.created.rawValue] as? String)
        let changed = Date.fromString(string: dict[TodoCodingKeys.changed.rawValue] as? String)
        
        guard let id, let text, let completed, let created else {
            return nil
        }
        
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.completed = completed
        self.created = created
        self.changed = changed
    }
    
    private static func convertToData(json: Any) -> Data? {
        guard let json = json as? String else {
            return json as? Data
        }
        return Data(json.utf8)
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard let jsonData = convertToData(json: json), let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            return nil
        }
        
        let id = jsonObject[TodoCodingKeys.id.rawValue] as? String
        let text = jsonObject[TodoCodingKeys.text.rawValue] as? String
        let priority = jsonObject[TodoCodingKeys.priority.rawValue] as? Priority ?? .neutral
        let deadline = Date.fromString(string: jsonObject[TodoCodingKeys.deadline.rawValue] as? String)
        let completed = jsonObject[TodoCodingKeys.completed.rawValue] as? Bool
        let created = Date.fromString(string: jsonObject[TodoCodingKeys.created.rawValue] as? String)
        let changed = Date.fromString(string: jsonObject[TodoCodingKeys.changed.rawValue] as? String)
        
        guard let id, let text, let completed, let created else {
            return nil
        }
        
        return TodoItem(id: id, text: text, priority: priority, deadline: deadline, completed: completed, created: created, changed: changed)
    }
    
    var json: Any {
        var properties = [String: Any]()
        
        properties[TodoCodingKeys.id.rawValue] = id
        properties[TodoCodingKeys.text.rawValue] = text
        properties[TodoCodingKeys.completed.rawValue] = completed
        properties[TodoCodingKeys.created.rawValue] = created.string()
        
        if priority != .neutral {
            properties[TodoCodingKeys.priority.rawValue] = priority.rawValue
        }
        
        if let deadline {
            properties[TodoCodingKeys.deadline.rawValue] = deadline.string()
        }
        
        if let changed {
            properties[TodoCodingKeys.changed.rawValue] = changed.string()
        }
        
        return properties
        
    }
}
