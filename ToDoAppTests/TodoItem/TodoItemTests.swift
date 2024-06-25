//
//  TodoItemTests.swift
//  ToDoAppTests
//
//  Created by Dmitriy Kalyakin on 25.06.2024.
//

import XCTest
@testable import ToDoApp

final class TodoItemTests: XCTestCase {
    
    func testTodoItemFull() {
        let todoItem = TodoItem(
            id: TodoItemTestValues.id,
            text: TodoItemTestValues.text,
            priority: TodoItemTestValues.high,
            deadline: TodoItemTestValues.date,
            completed: true,
            created: TodoItemTestValues.date,
            changed: TodoItemTestValues.date
        )
        
        XCTAssertEqual(todoItem.id, TodoItemTestValues.id)
        XCTAssertEqual(todoItem.text, TodoItemTestValues.text)
        XCTAssertEqual(todoItem.priority, TodoItemTestValues.high)
        XCTAssertEqual(todoItem.deadline, TodoItemTestValues.date)
        XCTAssertEqual(todoItem.completed, true)
        XCTAssertEqual(todoItem.created, TodoItemTestValues.date)
        XCTAssertEqual(todoItem.changed, TodoItemTestValues.date)
    }
    
    func testTodoItemMinimal() {
        let todoItem = TodoItem(
            text: TodoItemTestValues.text,
            priority: TodoItemTestValues.neutral,
            created: TodoItemTestValues.date
        )
        
        XCTAssertNotNil(todoItem.id)
        XCTAssertEqual(todoItem.text, TodoItemTestValues.text)
        XCTAssertEqual(todoItem.priority, TodoItemTestValues.neutral)
        XCTAssertNil(todoItem.deadline)
        XCTAssertEqual(todoItem.completed, false)
        XCTAssertEqual(todoItem.created, TodoItemTestValues.date)
        XCTAssertNil(todoItem.changed)
    }
}
