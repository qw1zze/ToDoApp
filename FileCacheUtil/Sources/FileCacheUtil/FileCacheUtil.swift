import CocoaLumberjackSwift
import Foundation

enum JSONError: Error {
    case notValidTodoItem
    case error(String)
}

public final class FileCache<ItemType: FileCachable> {
    private(set) var items = [ItemType]()

    let logger = DDOSLogger.sharedInstance

    public init() {}

    public func getItems() -> [ItemType] {
        return items
    }
    
    public func fetchItems(items: [ItemType]) {
        self.items = items
        
        DDLogInfo("FETCH FILECACHE")
    }

    private func convertToData() throws -> Data {
        let data = items.map { $0.json }
        return try JSONSerialization.data(withJSONObject: data)
    }

    public func addTodo(_ item: ItemType) {
        if let existedIndex = items.firstIndex(where: { $0.id == item.id}) {
            items[existedIndex] = item
            DDLogInfo("TODO UPDATING")
            return
        }
        items.append(item)
        DDLogInfo("TODO ADDING")
    }

    public func removeTodo(id: String) -> ItemType? {
        guard let existedIndex = items.firstIndex(where: { $0.id == id}) else {
            return nil
        }
        let deletedTodo = items[existedIndex]
        items.remove(at: existedIndex)
        DDLogInfo("TODO DELETING")
        return deletedTodo
    }

    public func updateTodo(_ item: ItemType) {
        for index in 0..<items.count where items[index].id == item.id {
            items[index] = item
            return
        }
    }

    public func saveToFile(fileName: String) throws {
        guard let fileUrl = try? FileManager.getUrl(fileName: fileName) else {
            throw FileManagerError.fileNotFound
        }
        let data = try convertToData()
        try data.write(to: fileUrl)
        DDLogInfo("TODOS SAVING")
    }

    public func readFromFile(fileName: String) throws {
        if !FileManager.isExists(fileName: fileName) {
            throw FileManagerError.fileIsExist
        }

        let fileUrl = try FileManager.getUrl(fileName: fileName)
        let jsonData = try Data(contentsOf: fileUrl)
        let jsonObject = (try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]]) ?? []
        items = jsonObject.compactMap { ItemType(dict: $0) }
        DDLogInfo("TODOS READING")
    }
}
