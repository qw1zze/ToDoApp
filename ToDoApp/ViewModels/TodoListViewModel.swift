//
//  TodoListViewController.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 29.06.2024.
//

import SwiftUI

final class TodoListViewModel: ObservableObject {
    @Published var fileCache: FileCache
    @Published var todoItems: [TodoItem]
    @Published var filterCompleted = true
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
        self.todoItems = fileCache.todoItems
    }
    
    var items: Array<TodoItem> {
        let items: Array<TodoItem>
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
    
    func addTodo(_ todo: TodoItem?) {
        guard let todo = todo else {
            return
        }
        fileCache.addTodo(todo)
        todoItems.append(todo)
    }
    
    func update(oldValue: TodoItem?, newValue: TodoItem?) {
        guard let oldValue = oldValue else {
            return
        }
        if let newValue = newValue {
            fileCache.updateTodo(newValue)
        } else {
            guard let existedIndex = todoItems.firstIndex(where: { $0.id == oldValue.id}) else {
                return
            }
            let deletedTodo = todoItems[existedIndex]
            todoItems.remove(at: existedIndex)
            fileCache.removeTodo(id: oldValue.id)
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
