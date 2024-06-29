//
//  TodoListViewController.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 29.06.2024.
//

import Foundation

final class TodoListViewModel: ObservableObject {
    @Published var fileCache: FileCache
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
    }
}
