//
//  FileCacheTests.swift
//  ToDoAppTests
//
//  Created by Dmitriy Kalyakin on 25.06.2024.
//

@testable import ToDoApp
import XCTest

struct FileCacheTestValues {
    static let todoFirst = TodoItem(text: "Example text", priority: .high, created: Date.now, changed: Date.now)
    static let todoSecond = TodoItem(text: "Another text", priority: .neutral, created: Date.now)
}

final class FileCacheTests: XCTestCase {

    func testAddTodoNew() {
        let fileCache = FileCacheLocal()
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
        let fileCache = FileCacheLocal()
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
        let fileCache = FileCacheLocal()
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
        let fileCache = FileCacheLocal()
        fileCache.addTodo(FileCacheTestValues.todoFirst)
        let removedTodo = fileCache.removeTodo(id: FileCacheTestValues.todoSecond.id)

        XCTAssertTrue(fileCache.todoItems.count == 1)
        XCTAssertNil(removedTodo)
    }

    func testSaveAndRead() {
        let fileCache = FileCacheLocal()
        fileCache.addTodo(FileCacheTestValues.todoFirst)
        fileCache.addTodo(FileCacheTestValues.todoSecond)
        try? fileCache.saveToFile(fileName: "testFile")

        let newFileCache = FileCacheLocal()
        try? newFileCache.readFromFile(fileName: "testFile")

        XCTAssertTrue(newFileCache.todoItems.count == fileCache.todoItems.count)

        for ind in 0..<fileCache.todoItems.count {
            XCTAssertEqual(fileCache.todoItems[ind].id, newFileCache.todoItems[ind].id)
            XCTAssertEqual(fileCache.todoItems[ind].text, newFileCache.todoItems[ind].text)
            XCTAssertEqual(fileCache.todoItems[ind].deadline?.description,
                           newFileCache.todoItems[ind].deadline?.description)
            XCTAssertEqual(fileCache.todoItems[ind].completed, newFileCache.todoItems[ind].completed)
            XCTAssertEqual(fileCache.todoItems[ind].created.description,
                           newFileCache.todoItems[ind].created.description)
            XCTAssertEqual(fileCache.todoItems[ind].changed?.description,
                           newFileCache.todoItems[ind].changed?.description)
            XCTAssertEqual(fileCache.todoItems[ind].priority, newFileCache.todoItems[ind].priority)
        }
    }
}
