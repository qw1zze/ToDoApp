import Foundation
import SwiftData

@Model
class TodoItemData {
    @Attribute(.unique)
    let id: String
    
    var text: String
    
    @Transient var priority: Priority {
        return Priority(rawValue: self.priorityRaw) ?? .neutral
    }
    var priorityRaw: String
    
    var deadline: Date?
    var completed: Bool
    var created: Date
    var changed: Date?
    
    @Transient var category: Category? {
        return Category(rawValue: self.categoryRaw ?? 0)
    }
    var categoryRaw: Int?
    
    init(id: String, text: String, priority: Priority, deadline: Date?, completed: Bool, created: Date, changed: Date?, category: Category?) {
        self.id = id
        self.text = text
        self.priorityRaw = priority.rawValue
        self.deadline = deadline
        self.completed = completed
        self.created = created
        self.changed = changed
        self.categoryRaw = category?.rawValue
    }
    
    init(from item: TodoItem) {
        self.id = item.id
        self.text = item.text
        self.priorityRaw = item.priority.rawValue
        self.deadline = item.deadline
        self.completed = item.completed
        self.created = item.created
        self.changed = item.changed
        self.categoryRaw = item.category?.rawValue
    }
    
    func getTodoItem() -> TodoItem {
        return TodoItem(id: self.id,
                        text: self.text,
                        priority: self.priority,
                        deadline: self.deadline,
                        completed: self.completed,
                        created: self.created,
                        changed: self.changed,
                        category: self.category)
    }
}
