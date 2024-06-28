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
    @Published var priority: Priority
    @Published var hasDeadline: Bool
    @Published var deadline: Date
    @Published var IsShowDatePicker: Bool
    
    var hasDatePicker: Bool {
        return hasDeadline && IsShowDatePicker
    }
    
    private var fileCacheModel: FileCache
    
    init(todoItem: TodoItem?, fileCacheModel: FileCache) {
        self.todoItem = todoItem
        self.taskText = todoItem?.text ?? ""
        self.priority = todoItem?.priority ?? .neutral
        self.hasDeadline = todoItem?.deadline != nil
        self.deadline = todoItem?.deadline ?? Date()
        self.fileCacheModel = fileCacheModel
        self.IsShowDatePicker = false
    }
    
    func saveTodoItem() {
        let todoItem = TodoItem(id: todoItem?.id ?? UUID().uuidString,
                                text: taskText,
                                priority: priority,
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
    
    func hideDatePicker() {
        IsShowDatePicker = false
    }
    
    func toggleDatePicker() {
        IsShowDatePicker.toggle()
    }
    
    func changeStateDatePicker() {
        if !hasDeadline {
            IsShowDatePicker = false
        } else {
            IsShowDatePicker = true
        }
    }
    
    func setDeadlineDefault() {
        deadline = Date().addingTimeInterval(86400)
    }
}
