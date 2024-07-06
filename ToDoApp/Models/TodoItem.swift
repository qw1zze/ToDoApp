import Foundation
import SwiftUI

struct TodoItem: Identifiable {
    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let completed: Bool
    let created: Date
    let changed: Date?
    let category: Category?
    
    init(id: String = UUID().uuidString,
         text: String, 
         priority: Priority,
         deadline: Date? = nil,
         completed: Bool = false,
         created: Date, 
         changed: Date? = nil,
         category: Category? = nil
    ) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.completed = completed
        self.created = created
        self.changed = changed
        self.category = category ?? .other
    }
}

enum Category: Int {
    case work
    case learn
    case hobby
    case other
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .work
        case 1:
            self = .learn
        case 2:
            self = .hobby
        case 3:
            self = .other
        default:
            self = .other
        }
    }
    
    func getInt() -> Int {
        switch self {
        case .work:
            return 0
        case .learn:
            return 1
        case .hobby:
            return 2
        case .other:
            return 3
        }
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
    case category = "category"
}
