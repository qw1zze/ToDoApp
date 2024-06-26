//
//  TodoItemViewModel.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 26.06.2024.
//

import SwiftUI

final class TodoItemViewModel: ObservableObject {
    @Published var todoItem: TodoItem?
    @Published var taskText: String
    @Published var prioity: Priority
    @Published var hasDeadline: Bool
    @Published var deadline: Date
    
    private var fileCacheModel: FileCache
    
    init(todoItem: TodoItem?, fileCacheModel: FileCache) {
        self.todoItem = todoItem
        self.taskText = todoItem?.text ?? ""
        self.prioity = todoItem?.priority ?? .neutral
        self.hasDeadline = todoItem?.deadline != nil
        self.deadline = todoItem?.deadline ?? Date()
        self.fileCacheModel = fileCacheModel
    }
    
    func saveTodoItem() {
        let todoItem = TodoItem(id: todoItem?.id ?? UUID().uuidString,
                                text: taskText,
                                priority: prioity,
                                deadline: hasDeadline ? deadline : nil,
                                completed: todoItem?.completed ?? false,
                                created: todoItem?.created ?? Date(),
                                changed: Date()
        )
        fileCacheModel.addTodo(todoItem)
    }
    
    func deleteTodoItem() {
        fileCacheModel.removeTodo(id: todoItem?.id ?? "")
    }
}
