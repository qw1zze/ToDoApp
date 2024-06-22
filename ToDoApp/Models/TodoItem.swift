//
//  TodoItem.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 22.06.2024.
//

import Foundation

enum Priority: String {
    case low
    case neutral
    case high
}

struct TodoItem: Hashable {
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension TodoItem {
    init?(dict: [String: Any]) {
        let id = dict["id"] as? String
        let text = dict["text"] as? String
        let priority = dict["priority"] as? Priority ?? .neutral
        let deadline = Date.fromString(string: dict["deadline"] as? String)
        let completed = dict["completed"] as? Bool
        let created = Date.fromString(string: dict["created"] as? String)
        let changed = Date.fromString(string: dict["changed"] as? String)
        
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
        
        let id = jsonObject["id"] as? String
        let text = jsonObject["text"] as? String
        let priority = jsonObject["priority"] as? Priority ?? .neutral
        let deadline = Date.fromString(string: jsonObject["deadline"] as? String)
        let completed = jsonObject["completed"] as? Bool
        let created = Date.fromString(string: jsonObject["created"] as? String)
        let changed = Date.fromString(string: jsonObject["changed"] as? String)
        
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
        properties["created"] = created.string()
        
        if priority != .neutral {
            properties["priority"] = priority.rawValue
        }
        
        if let deadline {
            properties["deadline"] = deadline.string()
        }
        
        if let changed {
            properties["changed"] = changed.string()
        }
        
        return properties
        
    }
}

extension Date {
    func string() -> String {
        return ISO8601DateFormatter().string(from: self)
    }
    
    static func fromString(string: String?) -> Date? {
        guard let string else {return nil}
        return ISO8601DateFormatter().date(from: string)
    }
 }
