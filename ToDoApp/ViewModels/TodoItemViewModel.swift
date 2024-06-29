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
    
    @Published var update: (TodoItem?) -> Void
    
    var hasDatePicker: Bool {
        return hasDeadline && IsShowDatePicker
    }
    
    init(todoItem: TodoItem?, update: @escaping (TodoItem?) -> Void) {
        self.todoItem = todoItem
        self.taskText = todoItem?.text ?? ""
        self.priority = todoItem?.priority ?? .neutral
        self.hasDeadline = todoItem?.deadline != nil
        self.deadline = todoItem?.deadline ?? Date()
        self.IsShowDatePicker = false
        self.update = update
    }
    
    func saveTodoItem() -> TodoItem {
        return TodoItem(id: todoItem?.id ?? UUID().uuidString,
                                text: taskText,
                                priority: priority,
                                deadline: hasDeadline ? deadline : nil,
                                completed: todoItem?.completed ?? false,
                                created: todoItem?.created ?? Date(),
                                changed: Date()
        )
    }
    
    func deleteTodoItem() -> TodoItem? {
        return nil
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
