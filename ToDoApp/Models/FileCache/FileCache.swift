import CocoaLumberjackSwift
import Foundation
import SwiftData

enum JSONError: Error {
    case notValidTodoItem
    case error(String)
}

final class FileCache {
    private(set) var items = [TodoItem]()
    
    let logger = DDOSLogger.sharedInstance
    
    internal let modelContainer: ModelContainer?
    
    public init() {
        do {
            modelContainer = try ModelContainer(for: TodoItemData.self)
        } catch {
            modelContainer = nil
            DDLogInfo("ERROR CREATE ModelContainer")
        }
    }

    func getItems() -> [TodoItem] {
        return items
    }
    
    func fetchItems(items: [TodoItem]) {
        self.items = items
        
        DDLogInfo("FETCH FILECACHE")
    }

    private func convertToData() throws -> Data {
        let data = items.map { $0.json }
        return try JSONSerialization.data(withJSONObject: data)
    }

    func addTodo(_ item: TodoItem) -> Bool{
        if let existedIndex = items.firstIndex(where: { $0.id == item.id}) {
            items[existedIndex] = item
            DDLogInfo("TODO UPDATING")
            return false
        }
        items.append(item)
        DDLogInfo("TODO ADDING")
        return true
    }

    func removeTodo(id: String) -> TodoItem? {
        guard let existedIndex = items.firstIndex(where: { $0.id == id}) else {
            return nil
        }
        let deletedTodo = items[existedIndex]
        items.remove(at: existedIndex)
        DDLogInfo("TODO DELETING")
        return deletedTodo
    }

    func updateTodo(_ item: TodoItem) {
        for index in 0..<items.count where items[index].id == item.id {
            items[index] = item
            return
        }
    }

    func saveToFile(fileName: String) throws {
        guard let fileUrl = try? FileManager.getUrl(fileName: fileName) else {
            throw FileManagerError.fileNotFound
        }
        let data = try convertToData()
        try data.write(to: fileUrl)
        DDLogInfo("TODOS SAVING")
    }

    func readFromFile(fileName: String) throws {
        if !FileManager.isExists(fileName: fileName) {
            throw FileManagerError.fileIsExist
        }

        let fileUrl = try FileManager.getUrl(fileName: fileName)
        let jsonData = try Data(contentsOf: fileUrl)
        let jsonObject = (try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]]) ?? []
        items = jsonObject.compactMap { TodoItem(dict: $0) }
        DDLogInfo("TODOS READING")
    }
}
