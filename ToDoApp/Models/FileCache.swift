//
//  FileCache.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 22.06.2024.
//

import Foundation

class FileCache {
    private(set) var todoItems = Set<TodoItem>()
    
    private func convertToData() -> Data? {
        var data = [Any]()
        for todo in todoItems {
            data.append(todo.json)
        }
        return try? JSONSerialization.data(withJSONObject: data)
    }
    
    func addTodo(todo: TodoItem) {
        todoItems.insert(todo)
    }
    
    func removeTodo(id: String) {
        let todo = TodoItem(id: id, text: "", priority: .neutral, deadline: nil, completed: false, created: Date(), changed: nil)
        todoItems.remove(todo)
    }
    
    func saveToFile(file: URL) throws {
        let data = convertToData() ?? Data()
        try data.write(to: file)
    }
    
    func readFromFile(file: URL) throws {
        guard let jsonData = try? Data(contentsOf: file), let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
            return
        }

        todoItems = Set<TodoItem>()
        for item in jsonObject {
            guard let item = TodoItem(dict: item) else {
                throw NSError(domain: "LoadingError", code: 0)
            }
            todoItems.insert(item)
        }
    }
}
