//
//  FileCache.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 22.06.2024.
//

import Foundation

enum JSONError: Error {
    case notValidTodoItem
    case error(String)
}

class FileCache {
    private(set) var todoItems = [TodoItem]()
    
    private func convertToData() -> Data? {
        let data = Array(todoItems).map { $0.json }
        return try? JSONSerialization.data(withJSONObject: data)
    }
    
    func addTodo(_ todo: TodoItem) {
        if let existedIndex = todoItems.firstIndex(where: { $0.id == todo.id}) {
            todoItems[existedIndex] = todo
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
    
    func saveToFile(file: URL) throws {
        let data = convertToData() ?? Data()
        try data.write(to: file)
    }
    
    func readFromFile(file: URL) throws {
        let jsonData = try Data(contentsOf: file)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] ?? []
        
        todoItems = [TodoItem]()
        for item in jsonObject {
            guard let item = TodoItem(dict: item) else {
                throw JSONError.notValidTodoItem
            }
            todoItems.append(item)
        }
    }
}
