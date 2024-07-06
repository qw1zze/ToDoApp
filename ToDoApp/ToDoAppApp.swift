//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 22.06.2024.
//

import SwiftUI

@main
struct ToDoAppApp: App {
    var body: some Scene {
        WindowGroup { // Оставил для удобства проверки
            TodoListView(viewModel: TodoListViewModel(fileCache: {
                let fileCache = FileCacheLocal()
                fileCache.addTodo(TodoItem(text: "Закончить смотреть лекцию", priority: .neutral, deadline: Date().addingTimeInterval(86400 * 2), completed: false, created: Date(), changed: Date()))
                fileCache.addTodo(TodoItem(text: "Сходить в зал", priority: .neutral, deadline: Date().addingTimeInterval(86400), completed: false, created: Date(), changed: Date()))
                fileCache.addTodo(TodoItem(text: "Посидеть с друзьями", priority: .low, deadline: nil, completed: false, created: Date(), changed: Date()))
                fileCache.addTodo(TodoItem(text: "Сделать очень сложную таску с очень большим описанием и очень близкм дедлайном в объеме на 3 строки",
                                           priority: .neutral, deadline: Date().addingTimeInterval(86400 * 4), completed: false, created: Date(), changed: Date()))
                fileCache.addTodo(TodoItem(text: "Купить клавиатуру", priority: .high, deadline: nil, completed: false, created: Date(), changed: Date()))
                fileCache.addTodo(TodoItem(text: "Поесть ягоды", priority: .neutral, deadline: nil, completed: true, created: Date(), changed: Date()))
                fileCache.addTodo(TodoItem(text: "Решить задачу по алгосам", priority: .neutral, deadline: Date().addingTimeInterval(86400 * 4), completed: false, created: Date(), changed: Date()))
                fileCache.addTodo(TodoItem(text: "Обновить мак", priority: .low, deadline: Date().addingTimeInterval(86400 * 4), completed: false, created: Date(), changed: Date()))
                fileCache.addTodo(TodoItem(text: "Сверстать экран на ките", priority: .high, deadline: Date().addingTimeInterval(86400), completed: true, created: Date(), changed: Date()))
                fileCache.addTodo(TodoItem(text: "Встретить друга с самолета", priority: .high, deadline: Date().addingTimeInterval(86400), completed: false, created: Date(), changed: Date()))
                fileCache.addTodo(TodoItem(text: "Поспать", priority: .high, deadline: Date().addingTimeInterval(86400 * 3), completed: false, created: Date(), changed: Date()))
                return fileCache
            }()))
        }
    }
}
