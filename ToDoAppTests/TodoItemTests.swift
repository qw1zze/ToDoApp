//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Dmitriy Kalyakin on 22.06.2024.
//

import XCTest
@testable import ToDoApp

final class TodoItemTests: XCTestCase {
    func testSerialization() throws {
        var todo1 = TodoItem(id: "1", text: "Test struct", priority: .neutral, deadline: nil, completed: true, created: Date.now, changed: Date.now)
        var todo2 = TodoItem(text: "Test struct", priority: .low, deadline: Date.now, completed: true, created: Date.now, changed: nil)
        var todo3 = TodoItem(text: "Test struct", priority: .high, deadline: Date.now, completed: false, created: Date.now, changed: nil)
        print(todo1)
        for todo in [todo1, todo2, todo3] {
            let jsonData = todo.json as! [String: Any]
            
            XCTAssertNotNil(jsonData)
            
            XCTAssertEqual(jsonData["id"] as? String, todo.id)
            XCTAssertEqual(jsonData["text"] as? String, todo.text)
            XCTAssertEqual(jsonData["priority"] as? String, todo.priority == .neutral ? nil : todo.priority.rawValue)
            XCTAssertEqual(jsonData["deadline"] as? String, todo.deadline?.string())
            XCTAssertEqual(jsonData["completed"] as? Bool, todo.completed)
            XCTAssertEqual(jsonData["created"] as? String, todo.created.string())
            XCTAssertEqual(jsonData["changed"] as? String, todo.changed?.string())
        }
    }
    
    func testJsonParsing() throws {
        let str = "{\"completed\":true,\"created\":\"2024-06-22T02:26:10Z\",\"id\":\"3\",\"changed\":\"2024-06-22T02:26:10Z\",\"text\":\"Text\"}"
        
        let item = TodoItem.parse(json: str)
            
        XCTAssertNotNil(item)   
            
        XCTAssertEqual(item?.id, "3")
        XCTAssertEqual(item?.text, "Text")
        XCTAssertEqual(item?.completed, true)
        XCTAssertEqual(item?.created.string(), "2024-06-22T02:26:10Z")
        XCTAssertEqual(item?.changed?.string(), "2024-06-22T02:26:10Z")
        
    }
}
