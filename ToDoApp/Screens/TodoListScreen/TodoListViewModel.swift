import SwiftUI

final class TodoListViewModel: ObservableObject {
    @Published var fileCache: FileCache
    @Published var todoItems: [TodoItem]
    @Published var filterCompleted = true
    @Published var isShownTodo: Bool = false

    init(fileCache: FileCache) {
        self.fileCache = fileCache
        self.todoItems = fileCache.todoItems
    }

    var items: [TodoItem] {
        let items: [TodoItem]
        if filterCompleted {
            items = todoItems.filter({$0.completed == false})
        } else {
            items = todoItems
        }
        return items
    }

    func getCompletedCount() -> Int {
        return todoItems.filter({$0.completed == true}).count
    }

    func toggleFilter() {
        filterCompleted.toggle()
    }

    func showTodo() {
        isShownTodo = true
    }

    func addTodo(_ todo: TodoItem?) {
        guard let todo = todo else {
            return
        }
        fileCache.addTodo(todo)
        todoItems = fileCache.todoItems
    }

    func update() {
        todoItems = fileCache.todoItems
    }

    func update(oldValue: TodoItem?, newValue: TodoItem?) {
        guard let oldValue = oldValue else {
            return
        }
        if let newValue = newValue {
            fileCache.updateTodo(newValue)
            todoItems = fileCache.todoItems
        } else {
            guard let existedIndex = fileCache.todoItems.firstIndex(where: { $0.id == oldValue.id}) else {
                return
            }
            _ = fileCache.removeTodo(id: fileCache.todoItems[existedIndex].id)
            todoItems = fileCache.todoItems
        }

    }

    func completeTask(_ todo: TodoItem) {
        let completedTodo = TodoItem(id: todo.id,
                                     text: todo.text,
                                     priority: todo.priority,
                                     deadline: todo.deadline,
                                     completed: true,
                                     created: todo.created,
                                     changed: todo.changed)
        fileCache.updateTodo(completedTodo)
        self.todoItems = fileCache.todoItems
    }

    func uncompleteTask(_ todo: TodoItem) {
        let completedTodo = TodoItem(id: todo.id,
                                     text: todo.text,
                                     priority: todo.priority,
                                     deadline: todo.deadline,
                                     completed: false,
                                     created: todo.created,
                                     changed: todo.changed)
        fileCache.updateTodo(completedTodo)
        self.todoItems = fileCache.todoItems
    }

    func toggleTask(_ todo: TodoItem) {
        let completedTodo = TodoItem(id: todo.id,
                                     text: todo.text,
                                     priority: todo.priority,
                                     deadline: todo.deadline,
                                     completed: !todo.completed,
                                     created: todo.created,
                                     changed: todo.changed)
        fileCache.updateTodo(completedTodo)
        self.todoItems = fileCache.todoItems
    }

    func deleteTodo(_ todo: TodoItem) {
        self.update(oldValue: todo, newValue: nil)
        todoItems = fileCache.todoItems
    }
}
