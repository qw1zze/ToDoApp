import Foundation
import CocoaLumberjackSwift
import SwiftData

extension FileCache {
    enum SortTodo {
        case ascending
        case descending
    }
    
    enum FilterTodo {
        case completed(Bool)
        case deadline(Date)
    }
    
    func getDescriptor(from sort: SortTodo) -> SortDescriptor<TodoItemData> {
        switch sort {
        case .ascending:
            return SortDescriptor<TodoItemData>(\.created, order: .forward)
        case .descending:
            return SortDescriptor<TodoItemData>(\.created, order: .reverse)
        }
    }
    
    func getPredicate(from filter: FilterTodo) -> Predicate<TodoItemData> {
        switch filter {
        case .deadline(let date):
            return #Predicate { item in
                if let deadline = item.deadline {
                    return deadline <= date
                } else {
                    return false
                }
            }
        case .completed(let completed):
            return #Predicate { $0.completed == completed }
        }
    }
    
    @MainActor
    func fetch(sort: SortTodo, filter: FilterTodo) -> [TodoItem] {
        let predicate = getPredicate(from: filter)
        let sortDescriptor = getDescriptor(from: sort)
        
        let fetchDescriptor = FetchDescriptor<TodoItemData>(
           predicate: predicate,
           sortBy: [sortDescriptor]
         )

        do {
            guard let items = try modelContainer?.mainContext.fetch(
              fetchDescriptor
            ) else {
              throw FileCacheError.fetchError
            }
            
            var convertedItems = [TodoItem]()
            for item in items {
                convertedItems.append(item.getTodoItem())
            }
            return convertedItems
        } catch {
            DDLogInfo("ERROR FETCH WITH PARAMETERS")
            return []
        }
    }
}
