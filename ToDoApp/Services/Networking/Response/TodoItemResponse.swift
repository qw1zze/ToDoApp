import Foundation

struct TodoItemResponse: Codable {
    var status: String?
    var element: TodoItemCodable
    var revision: Int?
}
