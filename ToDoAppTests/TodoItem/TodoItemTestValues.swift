//
//  File.swift
//  ToDoAppTests
//
//  Created by Dmitriy Kalyakin on 25.06.2024.
//

import Foundation
@testable import ToDoApp

struct TodoItemTestValues {
    static let id = UUID().uuidString
    static let text = "Exaple text"
    static let date = Date.now
    static let neutral = Priority.neutral
    static let high = Priority.high
}
