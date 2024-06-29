//
//  ContentView.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 22.06.2024.
//

import SwiftUI

struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
    var body: some View {
        TodoListView(viewModel: TodoListViewModel(fileCache: {
            let fileCache = FileCache()
            fileCache.addTodo(TodoItem(text: "Сделать ДЗ", priority: .high, completed: false, created: Date()))
            fileCache.addTodo(TodoItem(text: "Очень длинная таска на несколько строк насколько хватает воображения в 5 утра", priority: .low, completed: false, created: Date()))
            fileCache.addTodo(TodoItem(text: "Выпить кофе", priority: .neutral, completed: true, created: Date()))
            fileCache.addTodo(TodoItem(text: "Сходить в зал", priority: .high, deadline: Date().addingTimeInterval(86400 * 3), completed: false, created: Date()))
            fileCache.addTodo(TodoItem(text: "Полежать", priority: .high, completed: false, created: Date()))
            return fileCache
        }()))
    }
}

#Preview {
    TodoListView(viewModel: TodoListViewModel(fileCache: {
        let fileCache = FileCache()
        fileCache.addTodo(TodoItem(text: "Сделать ДЗ", priority: .high, completed: false, created: Date()))
        fileCache.addTodo(TodoItem(text: "Очень длинная таска на несколько строк насколько хватает воображения в 5 утра", priority: .low, completed: false, created: Date()))
        fileCache.addTodo(TodoItem(text: "Выпить кофе", priority: .neutral, completed: true, created: Date()))
        fileCache.addTodo(TodoItem(text: "Сходить в зал", priority: .high, deadline: Date().addingTimeInterval(86400 * 3), completed: false, created: Date()))
        fileCache.addTodo(TodoItem(text: "Полежать", priority: .high, completed: false, created: Date()))
        return fileCache
    }()))
}
