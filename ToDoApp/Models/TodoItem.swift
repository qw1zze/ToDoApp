//
//  TodoItem.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 22.06.2024.
//

import Foundation

enum Priority {
    case low
    case neutral
    case high
}

struct TodoItem {
    var id: String
    var text: String
    var priority: Priority
    var deadline: Date?
    var completed: Bool
    var created: Date
    var changed: Date?
    
    init(id: String = UUID().uuidString, text: String, priority: Priority, deadline: Date?, completed: Bool, created: Date, changed: Date?) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.completed = completed
        self.created = created
        self.changed = changed
    }
}

extension TodoItem {
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
        
        let id = jsonObject["id"] as? String
        var text = jsonObject["text"] as? String
        var priority = jsonObject["priority"] as? Priority ?? .neutral
        var deadline = jsonObject["deadline"] as? Date
        var completed = jsonObject["completed"] as? Bool
        var created = jsonObject["created"] as? Date
        var changed = jsonObject["changed"] as? Date
        
        guard let id, let text, let completed, let created else {
            return nil
        }
        
        return TodoItem(id: id, text: text, priority: priority, deadline: deadline, completed: completed, created: created, changed: changed)
    }
    
    var json: Any {
        var properties = [String: Any]()
        
        properties["id"] = id
        properties["text"] = text
        properties["completed"] = completed
        properties["created"] = created
        
        if priority != .neutral {
            properties["priority"] = priority
        }
        
        if let deadline {
            properties["deadline"] = deadline
        }
        
        if let changed {
            properties["changed"] = changed
        }
        
        return (try? JSONSerialization.data(withJSONObject: properties)) ?? Data()
        
    }
}
