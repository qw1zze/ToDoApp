import Foundation

final class CalendarViewModel: ObservableObject {
    @Published var fileCache: FileCache
    @Published var todoItems: [TodoItem]
    @Published var source: [((String, String), [TodoItem])]
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
        self.todoItems = fileCache.todoItems
        self.source = CalendarViewModel.convertSource(fileCache.todoItems)
    }
    
    func completeTask(_ todo: TodoItem) -> TodoItem {
        let completedTodo = TodoItem(id: todo.id,
                                     text: todo.text,
                                     priority: todo.priority,
                                     deadline: todo.deadline,
                                     completed: true,
                                     created: todo.created,
                                     changed: todo.changed)
        fileCache.updateTodo(completedTodo)
        self.todoItems = fileCache.todoItems
        return completedTodo
    }
    
    func uncompleteTask(_ todo: TodoItem) -> TodoItem {
        let uncompletedTodo = TodoItem(id: todo.id,
                                     text: todo.text,
                                     priority: todo.priority,
                                     deadline: todo.deadline,
                                     completed: false,
                                     created: todo.created,
                                     changed: todo.changed)
        fileCache.updateTodo(uncompletedTodo)
        self.todoItems = fileCache.todoItems
        return uncompletedTodo
    }
    
    func updateItems() {
        self.source = CalendarViewModel.convertSource(self.fileCache.todoItems)
    }
    
    static func convertSource(_ items: [TodoItem]) -> [((String, String), [TodoItem])] {
        var source = [((String, String), [TodoItem])]()
        items.forEach { item in
            guard let deadline = item.deadline else {
                if let ind = source.firstIndex(where: { $0.0.0 == "Другое" }) {
                    source[ind].1.append(item)
                } else {
                    source.append((("Другое", ""), [item]))
                }
                return
            }
            
            if let ind = source.firstIndex(where: { $0.0.0 == deadline.getDayAndMonth().0 && $0.0.1 == deadline.getDayAndMonth().1 }) {
                source[ind].1.append(item)
            } else {
                source.append(((deadline.getDayAndMonth().0, deadline.getDayAndMonth().1), [item]))
            }
        }
        source.sort { first, second in
            first.0.0 < second.0.0
        }

        if let ind = source.firstIndex(where: { $0.0.0 == "Другое" }) {
            let item = source[ind]
            source.remove(at: ind)
            source.append(item)
        }
        return source
    }
}
