import Foundation

struct TodoListResponse: Codable {
    var status: String?
    var list: [TodoItemCodable]
    var revision: Int?
}
