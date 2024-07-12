import FileCacheUtil
import SwiftUI

final class TodoListViewModel: ObservableObject {
    @Published var fileCache: FileCache<TodoItem>
    @Published var todoItems: [TodoItem]
    @Published var filterCompleted = true
    @Published var isShownTodo: Bool = false

    init(fileCache: FileCache<TodoItem>) {
        self.fileCache = fileCache
        self.todoItems = fileCache.getItems()
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
        todoItems = fileCache.getItems()
    }
    func update() {
        todoItems = fileCache.getItems()
    }

    func update(oldValue: TodoItem?, newValue: TodoItem?) {
        guard let oldValue = oldValue else {
            return
        }
        if let newValue = newValue {
            fileCache.updateTodo(newValue)
            todoItems = fileCache.getItems()
        } else {
            guard let existedIndex = fileCache.getItems().firstIndex(where: { $0.id == oldValue.id}) else {
                return
            }
            _ = fileCache.removeTodo(id: fileCache.getItems()[existedIndex].id)
            todoItems = fileCache.getItems()
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
        self.todoItems = fileCache.getItems()
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
        self.todoItems = fileCache.getItems()
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
        self.todoItems = fileCache.getItems()
    }

    func deleteTodo(_ todo: TodoItem) {
        self.update(oldValue: todo, newValue: nil)
        todoItems = fileCache.getItems()
    }
}
