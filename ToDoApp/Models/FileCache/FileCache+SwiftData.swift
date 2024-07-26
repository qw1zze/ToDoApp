import Foundation
import SwiftData
import CocoaLumberjackSwift

enum FileCacheError: Error {
    case fetchError
    case updateError
}

extension FileCache {
    @MainActor
    func insert(_ todoItem: TodoItem) {
        let todoItemData = TodoItemData(from: todoItem)
        modelContainer?.mainContext.insert(todoItemData)
        save()
    }
    
    @MainActor
    func fetch() -> [TodoItem] {
        do {
            let descriptor = FetchDescriptor<TodoItemData>(sortBy: [.init(\.created)])
            
            guard let items = try modelContainer?.mainContext.fetch(descriptor) else {
                throw FileCacheError.fetchError
            }
            
            var converted = [TodoItem]()
            for item in items {
                converted.append(item.getTodoItem())
            }
            return converted
        } catch {
            DDLogInfo("ERROR FETCH ModelContainer")
            return []
        }
    }
    
    @MainActor
    func delete(_ todoItem: TodoItem) {
        do {
            let id = todoItem.id
            let descriptor = FetchDescriptor<TodoItemData>(predicate: #Predicate { item in
                item.id == id
            })
            
            guard let items = try modelContainer?.mainContext.fetch(descriptor) else {
                throw FileCacheError.fetchError
            }
            
            guard var item = items.first else {
                throw FileCacheError.updateError
            }
            
            modelContainer?.mainContext.delete(item)
            
            save()
        } catch {
            DDLogInfo("ERROR UPDATE ModelContainer")
        }
    }
    
    @MainActor
    func update(_ todoItem: TodoItem) {
        do {
            
            let id = todoItem.id
            let descriptor = FetchDescriptor<TodoItemData>(predicate: #Predicate { item in
                item.id == id
            })
            
            guard let items = try modelContainer?.mainContext.fetch(descriptor) else {
                throw FileCacheError.fetchError
            }
            
            guard var item = items.first else {
                throw FileCacheError.updateError
            }
            
            item.text = todoItem.text
            item.priorityRaw = todoItem.priority.rawValue
            item.deadline = todoItem.deadline
            item.completed = todoItem.completed
            item.created = todoItem.created
            item.changed = todoItem.changed
            item.categoryRaw = todoItem.category?.rawValue
            
            save()
        } catch {
            DDLogInfo("ERROR UPDATE ModelContainer")
        }
    }
    
    @MainActor
    private func save() {
        do {
            try modelContainer?.mainContext.save()
        } catch {
            DDLogInfo("ERROR SAVE CONTEXT")
        }
    }
}
