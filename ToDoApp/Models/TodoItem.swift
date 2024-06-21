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
