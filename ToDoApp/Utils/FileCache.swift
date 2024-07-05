import Foundation

enum JSONError: Error {
    case notValidTodoItem
    case error(String)
}

protocol FileCache {
    var todoItems: [TodoItem] { get }
    func addTodo(_ todo: TodoItem)
    func removeTodo(id: String) -> TodoItem?
    func updateTodo(_ todo: TodoItem)
    func saveToFile(fileName: String) throws
    func readFromFile(fileName: String) throws
}

final class FileCacheLocal: FileCache {
    private(set) var todoItems = [TodoItem]()
    
    private func convertToData() throws -> Data {
        let data = todoItems.map { $0.json }
        return try JSONSerialization.data(withJSONObject: data)
    }
    
    func addTodo(_ todo: TodoItem) {
        if let existedIndex = todoItems.firstIndex(where: { $0.id == todo.id}) {
            todoItems[existedIndex] = todo
            return
        }
        todoItems.append(todo)
    }
    
    func removeTodo(id: String) -> TodoItem? {
        guard let existedIndex = todoItems.firstIndex(where: { $0.id == id}) else {
            return nil
        }
        let deletedTodo = todoItems[existedIndex]
        todoItems.remove(at: existedIndex)
        return deletedTodo
    }
    
    func updateTodo(_ todo: TodoItem) {
        for i in 0..<todoItems.count {
            if todoItems[i].id == todo.id {
                todoItems[i] = todo
                return
            }
        }
    }
    
    func saveToFile(fileName: String) throws {
        guard let fileUrl = try? FileManager.getUrl(fileName: fileName) else {
            throw FileManagerError.fileNotFound
        }
        let data = try convertToData()
        try data.write(to: fileUrl)
    }
    
    func readFromFile(fileName: String) throws {
        if !FileManager.isExists(fileName: fileName) {
            throw FileManagerError.fileIsExist
        }
        
        let fileUrl = try FileManager.getUrl(fileName: fileName)
        let jsonData = try Data(contentsOf: fileUrl)
        let jsonObject = (try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]]) ?? []
        todoItems = jsonObject.compactMap { TodoItem(dict: $0) }
    }
}