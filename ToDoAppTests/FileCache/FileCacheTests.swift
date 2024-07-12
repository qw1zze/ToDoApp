import FileCacheUtil
@testable import ToDoApp
import XCTest

struct FileCacheTestValues {
    static let todoFirst = TodoItem(text: "Example text", priority: .high, created: Date.now, changed: Date.now)
    static let todoSecond = TodoItem(text: "Another text", priority: .neutral, created: Date.now)
}

final class FileCacheTests: XCTestCase {

    func testAddTodoNew() {
        let fileCache = FileCache<TodoItem>()
        fileCache.addTodo(FileCacheTestValues.todoFirst)

        XCTAssertFalse(fileCache.getItems().isEmpty)
        XCTAssertEqual(fileCache.getItems().first?.id, FileCacheTestValues.todoFirst.id)
        XCTAssertEqual(fileCache.getItems().first?.text, FileCacheTestValues.todoFirst.text)
        XCTAssertEqual(fileCache.getItems().first?.deadline, FileCacheTestValues.todoFirst.deadline)
        XCTAssertEqual(fileCache.getItems().first?.completed, FileCacheTestValues.todoFirst.completed)
        XCTAssertEqual(fileCache.getItems().first?.created, FileCacheTestValues.todoFirst.created)
        XCTAssertEqual(fileCache.getItems().first?.changed, FileCacheTestValues.todoFirst.changed)
        XCTAssertEqual(fileCache.getItems().first?.priority, FileCacheTestValues.todoFirst.priority)
    }

    func testAddExists() {
        let fileCache = FileCache<TodoItem>()
        fileCache.addTodo(FileCacheTestValues.todoFirst)
        fileCache.addTodo(FileCacheTestValues.todoFirst)

        XCTAssertTrue(fileCache.getItems().count == 1)
        XCTAssertEqual(fileCache.getItems().first?.id, FileCacheTestValues.todoFirst.id)
        XCTAssertEqual(fileCache.getItems().first?.text, FileCacheTestValues.todoFirst.text)
        XCTAssertEqual(fileCache.getItems().first?.deadline, FileCacheTestValues.todoFirst.deadline)
        XCTAssertEqual(fileCache.getItems().first?.completed, FileCacheTestValues.todoFirst.completed)
        XCTAssertEqual(fileCache.getItems().first?.created, FileCacheTestValues.todoFirst.created)
        XCTAssertEqual(fileCache.getItems().first?.changed, FileCacheTestValues.todoFirst.changed)
        XCTAssertEqual(fileCache.getItems().first?.priority, FileCacheTestValues.todoFirst.priority)
    }

    func testRemoveTodoExist() {
        let fileCache = FileCache<TodoItem>()
        fileCache.addTodo(FileCacheTestValues.todoFirst)
        let removedTodo = fileCache.removeTodo(id: FileCacheTestValues.todoFirst.id)

        XCTAssertTrue(fileCache.getItems().isEmpty)
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
        let fileCache = FileCache<TodoItem>()
        fileCache.addTodo(FileCacheTestValues.todoFirst)
        let removedTodo = fileCache.removeTodo(id: FileCacheTestValues.todoSecond.id)

        XCTAssertTrue(fileCache.getItems().count == 1)
        XCTAssertNil(removedTodo)
    }

    func testSaveAndRead() {
        let fileCache = FileCache<TodoItem>()
        fileCache.addTodo(FileCacheTestValues.todoFirst)
        fileCache.addTodo(FileCacheTestValues.todoSecond)
        try? fileCache.saveToFile(fileName: "testFile")

        let newFileCache = FileCache<TodoItem>()
        try? newFileCache.readFromFile(fileName: "testFile")

        XCTAssertTrue(newFileCache.getItems().count == fileCache.getItems().count)

        for ind in 0..<fileCache.getItems().count {
            XCTAssertEqual(fileCache.getItems()[ind].id, newFileCache.getItems()[ind].id)
            XCTAssertEqual(fileCache.getItems()[ind].text, newFileCache.getItems()[ind].text)
            XCTAssertEqual(fileCache.getItems()[ind].deadline?.description,
                           newFileCache.getItems()[ind].deadline?.description)
            XCTAssertEqual(fileCache.getItems()[ind].completed, newFileCache.getItems()[ind].completed)
            XCTAssertEqual(fileCache.getItems()[ind].created.description,
                           newFileCache.getItems()[ind].created.description)
            XCTAssertEqual(fileCache.getItems()[ind].changed?.description,
                           newFileCache.getItems()[ind].changed?.description)
            XCTAssertEqual(fileCache.getItems()[ind].priority, newFileCache.getItems()[ind].priority)
        }
    }
}
