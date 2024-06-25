//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Dmitriy Kalyakin on 22.06.2024.
//

import XCTest
@testable import ToDoApp

final class TodoItemJSONTests: XCTestCase {
    
    func testJsonParseWithFullDictionary() {
        let jsonDict: [String: Any] = [
            TodoCodingKeys.id.rawValue: TodoItemTestValues.id,
            TodoCodingKeys.text.rawValue: TodoItemTestValues.text,
            TodoCodingKeys.priority.rawValue: TodoItemTestValues.high.rawValue,
            TodoCodingKeys.deadline.rawValue: TodoItemTestValues.date.string(),
            TodoCodingKeys.completed.rawValue: true,
            TodoCodingKeys.created.rawValue: TodoItemTestValues.date.string(),
            TodoCodingKeys.changed.rawValue: TodoItemTestValues.date.string()
        ]
        
        let json = try? JSONSerialization.data(withJSONObject: jsonDict)
        XCTAssertNotNil(json)
        let todoItem = TodoItem.parse(json: json!)
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, TodoItemTestValues.id)
        XCTAssertEqual(todoItem?.text, TodoItemTestValues.text)
        XCTAssertEqual(todoItem?.priority, .high)
        XCTAssertEqual(todoItem?.completed, true)
        XCTAssertEqual(todoItem?.created, Date.fromString(string: TodoItemTestValues.date.string()))
        XCTAssertEqual(todoItem?.deadline, Date.fromString(string: TodoItemTestValues.date.string()))
        XCTAssertEqual(todoItem?.changed, Date.fromString(string: TodoItemTestValues.date.string()))
    }
    
    func testJsonParseWithMinimalDictionary() {
        let jsonDict: [String: Any] = [
            TodoCodingKeys.id.rawValue: TodoItemTestValues.id,
            TodoCodingKeys.text.rawValue: TodoItemTestValues.text,
            TodoCodingKeys.completed.rawValue: true,
            TodoCodingKeys.created.rawValue: TodoItemTestValues.date.string(),
        ]
        
        let json = try? JSONSerialization.data(withJSONObject: jsonDict)
        XCTAssertNotNil(json)
        let todoItem = TodoItem.parse(json: json!)
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, TodoItemTestValues.id)
        XCTAssertEqual(todoItem?.text, TodoItemTestValues.text)
        XCTAssertEqual(todoItem?.priority, .neutral)
        XCTAssertEqual(todoItem?.completed, true)
        XCTAssertEqual(todoItem?.created, Date.fromString(string: TodoItemTestValues.date.string()))
        XCTAssertNil(todoItem?.deadline)
        XCTAssertNil(todoItem?.changed)
    }
    
    func testJsonParseWithInvalidDictionary() {
        let jsonDict: [String: Any] = [
            TodoCodingKeys.id.rawValue: TodoItemTestValues.id,
            TodoCodingKeys.text.rawValue: TodoItemTestValues.text,
            TodoCodingKeys.completed.rawValue: TodoItemTestValues.date.string(),
            TodoCodingKeys.created.rawValue: TodoItemTestValues.date.string(),
        ]
        
        let json = try? JSONSerialization.data(withJSONObject: jsonDict)
        XCTAssertNotNil(json)
        let todoItem = TodoItem.parse(json: json!)
        XCTAssertNil(todoItem)
    }
    
    func testTodoWithFullJson() {
        let todoItem = TodoItem(
            id: TodoItemTestValues.id,
            text: TodoItemTestValues.text,
            priority: TodoItemTestValues.high,
            deadline: TodoItemTestValues.date,
            completed: true,
            created: TodoItemTestValues.date,
            changed: TodoItemTestValues.date
        )
        
        let json = todoItem.json as? [String: Any]
        XCTAssertNotNil(json)
        XCTAssertEqual(json?[TodoCodingKeys.id.rawValue] as? String, TodoItemTestValues.id)
        XCTAssertEqual(json?[TodoCodingKeys.text.rawValue] as? String, TodoItemTestValues.text)
        XCTAssertEqual(json?[TodoCodingKeys.priority.rawValue] as? String, TodoItemTestValues.high.rawValue)
        XCTAssertEqual(json?[TodoCodingKeys.completed.rawValue] as? Bool, true)
        XCTAssertEqual(json?[TodoCodingKeys.created.rawValue] as? String, TodoItemTestValues.date.string())
        XCTAssertEqual(json?[TodoCodingKeys.deadline.rawValue] as? String, TodoItemTestValues.date.string())
        XCTAssertEqual(json?[TodoCodingKeys.changed.rawValue] as? String, TodoItemTestValues.date.string())
    }
    
    func testTodoWithMinimalJson() {
        let todoItem = TodoItem(
            id: TodoItemTestValues.id,
            text: TodoItemTestValues.text,
            priority: TodoItemTestValues.neutral,
            completed: false,
            created: TodoItemTestValues.date
        )
        
        let json = todoItem.json as? [String: Any]
        XCTAssertNotNil(json)
        XCTAssertEqual(json?[TodoCodingKeys.id.rawValue] as? String, TodoItemTestValues.id)
        XCTAssertEqual(json?[TodoCodingKeys.text.rawValue] as? String, TodoItemTestValues.text)
        XCTAssertNil(json?[TodoCodingKeys.priority.rawValue] as? String)
        XCTAssertEqual(json?[TodoCodingKeys.completed.rawValue] as? Bool, false)
        XCTAssertEqual(json?[TodoCodingKeys.created.rawValue] as? String, TodoItemTestValues.date.string())
        XCTAssertNil(json?[TodoCodingKeys.deadline.rawValue] as? String)
        XCTAssertNil(json?[TodoCodingKeys.changed.rawValue] as? String)
    }
}
