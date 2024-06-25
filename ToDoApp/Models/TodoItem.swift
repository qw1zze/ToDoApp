//
//  TodoItem.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 22.06.2024.
//

import Foundation

struct TodoItem {
    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let completed: Bool
    let created: Date
    let changed: Date?
    
    init(id: String = UUID().uuidString,
         text: String, 
         priority: Priority,
         deadline: Date? = nil,
         completed: Bool = false,
         created: Date, 
         changed: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.completed = completed
        self.created = created
        self.changed = changed
    }
}

enum Priority: String {
    case low
    case neutral
    case high
}

enum TodoCodingKeys: String, CaseIterable {
    case id = "id"
    case text = "text"
    case priority = "priority"
    case deadline = "deadline"
    case completed = "completed"
    case created = "created"
    case changed = "changed"
}
