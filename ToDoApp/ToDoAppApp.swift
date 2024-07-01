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
        WindowGroup {
            TodoListView(viewModel: TodoListViewModel(fileCache: FileCacheLocal()))
        }
    }
}
