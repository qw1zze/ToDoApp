import Foundation

struct TodoItemCodable: Codable {
    var id: String
    var text: String
    var importance: String
    var deadline: Int?
    var done: Bool
    var color: String?
    var createdAt: Int
    var changedAt: Int
    var lastUpdatedBy: String
    var files: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline
        case done
        case color
        case createdAt = "created_at"
        case changedAt = "changed_at"
        case lastUpdatedBy = "last_updated_by"
        case files
    }
    
    public init(from item: TodoItem) {
        self.id = item.id
        self.text = item.text
        self.importance = item.priority.rawValue
        self.deadline = item.deadline?.getTimestamp()
        self.done = item.completed
        self.createdAt = item.created.getTimestamp()
        self.changedAt = item.changed?.getTimestamp() ?? 0
        self.lastUpdatedBy = ""
        self.color = "#FFFFFF"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        importance = try container.decode(String.self, forKey: .importance)
        done = try container.decode(Bool.self, forKey: .done)
        deadline = try? container.decode(Int.self, forKey: .deadline)
        createdAt = try container.decode(Int.self, forKey: .createdAt)
        changedAt = (try? container.decode(Int.self, forKey: .changedAt)) ?? 0
        lastUpdatedBy = ""
    }
    
    public func toTodoItem() -> TodoItem {
        return TodoItem(id: self.id,
                        text: self.text,
                        priority: Priority(rawValue: self.importance) ?? .neutral,
                        deadline: Date.fromTimeStamp(from: self.deadline),
                        completed: self.done,
                        created: Date.fromTimeStamp(from: self.createdAt) ?? Date(),
                        changed: Date.fromTimeStamp(from: self.changedAt))
    }
}
