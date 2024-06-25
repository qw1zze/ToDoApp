//
//  FileCacheTests.swift
//  ToDoAppTests
//
//  Created by Dmitriy Kalyakin on 25.06.2024.
//

import XCTest
@testable import ToDoApp

struct FileCacheTestValues {
    static let todoFirst = TodoItem(text: "Example text", priority: .high, created: Date.now, changed: Date.now)
    static let todoSecond = TodoItem(text: "Another text", priority: .neutral, created: Date.now)
}

final class FileCacheTests: XCTestCase {

    func testAddTodoNew() {
        let fileCache = FileCache()
        fileCache.addTodo(FileCacheTestValues.todoFirst)
        
        XCTAssertFalse(fileCache.todoItems.isEmpty)
        XCTAssertEqual(fileCache.todoItems.first?.id, FileCacheTestValues.todoFirst.id)
        XCTAssertEqual(fileCache.todoItems.first?.text, FileCacheTestValues.todoFirst.text)
        XCTAssertEqual(fileCache.todoItems.first?.deadline, FileCacheTestValues.todoFirst.deadline)
        XCTAssertEqual(fileCache.todoItems.first?.completed, FileCacheTestValues.todoFirst.completed)
        XCTAssertEqual(fileCache.todoItems.first?.created, FileCacheTestValues.todoFirst.created)
        XCTAssertEqual(fileCache.todoItems.first?.changed, FileCacheTestValues.todoFirst.changed)
        XCTAssertEqual(fileCache.todoItems.first?.priority, FileCacheTestValues.todoFirst.priority)
    }
    
    func testAddExists() {
        let fileCache = FileCache()
        fileCache.addTodo(FileCacheTestValues.todoFirst)
        fileCache.addTodo(FileCacheTestValues.todoFirst)
        
        XCTAssertTrue(fileCache.todoItems.count == 1)
        XCTAssertEqual(fileCache.todoItems.first?.id, FileCacheTestValues.todoFirst.id)
        XCTAssertEqual(fileCache.todoItems.first?.text, FileCacheTestValues.todoFirst.text)
        XCTAssertEqual(fileCache.todoItems.first?.deadline, FileCacheTestValues.todoFirst.deadline)
        XCTAssertEqual(fileCache.todoItems.first?.completed, FileCacheTestValues.todoFirst.completed)
        XCTAssertEqual(fileCache.todoItems.first?.created, FileCacheTestValues.todoFirst.created)
        XCTAssertEqual(fileCache.todoItems.first?.changed, FileCacheTestValues.todoFirst.changed)
        XCTAssertEqual(fileCache.todoItems.first?.priority, FileCacheTestValues.todoFirst.priority)
    }
    
    func testRemoveTodoExist() {
        let fileCache = FileCache()
        fileCache.addTodo(FileCacheTestValues.todoFirst)
        let removedTodo = fileCache.removeTodo(id: FileCacheTestValues.todoFirst.id)
        
        XCTAssertTrue(fileCache.todoItems.isEmpty)
        XCTAssertNotNil(removedTodo)
        XCTAssertEqual(removedTodo?.id, FileCacheTestValues.todoFirst.id)
        XCTAssertEqual(removedTodo?.text, FileCacheTestValues.todoFirst.text)
        XCTAssertEqual(removedTodo?.deadline, FileCacheTestValues.todoFirst.deadline)
        XCTAssertEqual(removedTodo?.completed, FileCacheTestValues.todoFirst.completed)
        XCTAssertEqual(removedTodo?.created, FileCacheTestValues.todoFirst.created)
        XCTAssertEqual(removedTodo?.changed, FileCacheTestValues.todoFirst.changed)
        XCTAssertEqual(removedTodo?.priority, FileCacheTestValues.todoFirst.priority)
    }
    
    func testRemoveTodoNotExist() {
        let fileCache = FileCache()
        fileCache.addTodo(FileCacheTestValues.todoFirst)
        let removedTodo = fileCache.removeTodo(id: FileCacheTestValues.todoSecond.id)
        
        XCTAssertTrue(fileCache.todoItems.count == 1)
        XCTAssertNil(removedTodo)
    }
    
    func testSaveAndRead() {
        let fileCache = FileCache()
        fileCache.addTodo(FileCacheTestValues.todoFirst)
        fileCache.addTodo(FileCacheTestValues.todoSecond)
        try! fileCache.saveToFile(fileName: "testFile")
        
        let newFileCache = FileCache()
        try! newFileCache.readFromFile(fileName: "testFile")
        
        XCTAssertTrue(newFileCache.todoItems.count == fileCache.todoItems.count)
        
        
        for i in 0..<fileCache.todoItems.count {
            XCTAssertEqual(fileCache.todoItems[i].id, newFileCache.todoItems[i].id)
            XCTAssertEqual(fileCache.todoItems[i].text, newFileCache.todoItems[i].text)
            XCTAssertEqual(fileCache.todoItems[i].deadline?.description, newFileCache.todoItems[i].deadline?.description)
            XCTAssertEqual(fileCache.todoItems[i].completed, newFileCache.todoItems[i].completed)
            XCTAssertEqual(fileCache.todoItems[i].created.description, newFileCache.todoItems[i].created.description)
            XCTAssertEqual(fileCache.todoItems[i].changed?.description, newFileCache.todoItems[i].changed?.description)
            XCTAssertEqual(fileCache.todoItems[i].priority, newFileCache.todoItems[i].priority)
        }
    }
    
    
}
