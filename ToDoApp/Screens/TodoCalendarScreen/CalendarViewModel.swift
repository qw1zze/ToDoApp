import Foundation

final class CalendarViewModel: ObservableObject {
    @Published var fileCache: FileCache
    @Published var todoItems: [TodoItem]
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
        self.todoItems = fileCache.todoItems
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
}
