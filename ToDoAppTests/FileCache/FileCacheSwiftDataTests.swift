import XCTest
@testable import ToDoApp

final class FileCacheSwiftDataTests: XCTestCase {

    func testFileCacheInitWhenNormal() {
        var fileCache = FileCache()
        fileCache.modelContainer?.deleteAllData()
        XCTAssertNotNil(fileCache.modelContainer)
    }
    
    func testInsertWhenNormal() async {
        var fileCache = FileCache()
        fileCache.modelContainer?.deleteAllData()
        fileCache = FileCache()
        
        XCTAssertNotNil(fileCache.modelContainer)
        
        var todo = TodoItem(text: "test", priority: .high, created: Date.now)
        await fileCache.insert(todo)
        var items = await fileCache.fetch()
        XCTAssertEqual(items.count, 1)
        
        var item = items[0]
        XCTAssertEqual(item.id, todo.id)
        XCTAssertEqual(item.text, todo.text)
        XCTAssertEqual(item.priority, todo.priority)
        XCTAssertEqual(item.deadline, todo.deadline)
        XCTAssertEqual(item.completed, todo.completed)
        XCTAssertEqual(item.created, todo.created)
        XCTAssertEqual(item.changed, todo.changed)
    }
    
    func testFetchWhenEmpty() async {
        var fileCache = FileCache()
        fileCache.modelContainer?.deleteAllData()
        fileCache = FileCache()
        XCTAssertNotNil(fileCache.modelContainer)
        
        var items = await fileCache.fetch()
        XCTAssertEqual(items.count, 0)
    }
    
    func testFetchWhenNoEmpty() async {
        var fileCache = FileCache()
        fileCache.modelContainer?.deleteAllData()
        fileCache = FileCache()
        XCTAssertNotNil(fileCache.modelContainer)
        
        await fileCache.insert(TodoItem(text: "test", priority: .high, created: Date.now))
        await fileCache.insert(TodoItem(text: "test", priority: .high, created: Date.now))
        await fileCache.insert(TodoItem(text: "test", priority: .high, created: Date.now))
        
        var items = await fileCache.fetch()
        XCTAssertEqual(items.count, 3)
    }
    
    func testDeleteWhenContains() async {
        var fileCache = FileCache()
        fileCache.modelContainer?.deleteAllData()
        fileCache = FileCache()
        
        XCTAssertNotNil(fileCache.modelContainer)
        
        var todo = TodoItem(text: "test", priority: .high, created: Date.now)
        await fileCache.insert(todo)
        
        await fileCache.delete(todo)
        var count = await fileCache.fetch().count
        XCTAssertEqual(count, 0)
    }
    
    func testDeleteWhenNoContains() async {
        var fileCache = FileCache()
        fileCache.modelContainer?.deleteAllData()
        fileCache = FileCache()
        
        XCTAssertNotNil(fileCache.modelContainer)
        
        var todo = TodoItem(text: "test", priority: .high, created: Date.now)
        
        await fileCache.delete(todo)
        var count = await fileCache.fetch().count
        XCTAssertEqual(count, 0)
    }
    
    func testDeleteWhenContainsMore() async {
        var fileCache = FileCache()
        fileCache.modelContainer?.deleteAllData()
        fileCache = FileCache()
        
        XCTAssertNotNil(fileCache.modelContainer)
        
        var todo1 = TodoItem(text: "test1", priority: .high, created: Date.now)
        var todo2 = TodoItem(text: "test2", priority: .low, created: Date.now.addingTimeInterval(500))
        await fileCache.insert(todo1)
        await fileCache.insert(todo2)
        
        await fileCache.delete(todo1)
        var items = await fileCache.fetch()
        XCTAssertEqual(items.count, 1)
        
        var item = items[0]
        XCTAssertEqual(item.id, todo2.id)
        XCTAssertEqual(item.text, todo2.text)
        XCTAssertEqual(item.priority, todo2.priority)
        XCTAssertEqual(item.deadline, todo2.deadline)
        XCTAssertEqual(item.completed, todo2.completed)
        XCTAssertEqual(item.created, todo2.created)
        XCTAssertEqual(item.changed, todo2.changed)
    }
    
    func testUpdateWhenContains() async {
        var fileCache = FileCache()
        fileCache.modelContainer?.deleteAllData()
        fileCache = FileCache()
        
        XCTAssertNotNil(fileCache.modelContainer)
        
        var todo = TodoItem(text: "test", priority: .high, created: Date.now)
        await fileCache.insert(todo)
        
        var changedTodo = TodoItem(id: todo.id,
                                   text: "new",
                                   priority: .low,
                                   deadline: todo.deadline,
                                   completed: true,
                                   created: todo.created,
                                   changed: todo.changed,
                                   category: .learn)
        await fileCache.update(changedTodo)
        var items = await fileCache.fetch()
        XCTAssertEqual(items.count, 1)
        
        var item = items[0]
        XCTAssertEqual(item.id, changedTodo.id)
        XCTAssertEqual(item.text, changedTodo.text)
        XCTAssertEqual(item.priority, changedTodo.priority)
        XCTAssertEqual(item.deadline, changedTodo.deadline)
        XCTAssertEqual(item.completed, changedTodo.completed)
        XCTAssertEqual(item.created, changedTodo.created)
        XCTAssertEqual(item.changed, changedTodo.changed)
    }
    
    func testUpdateWhenNoContains() async {
        var fileCache = FileCache()
        fileCache.modelContainer?.deleteAllData()
        fileCache = FileCache()
        
        XCTAssertNotNil(fileCache.modelContainer)
        
        var todo = TodoItem(text: "test", priority: .high, created: Date.now)
        var changedTodo = TodoItem(id: todo.id,
                                   text: "new",
                                   priority: .low,
                                   deadline: todo.deadline,
                                   completed: true,
                                   created: todo.created,
                                   changed: todo.changed,
                                   category: .learn)
        await fileCache.update(changedTodo)
        var items = await fileCache.fetch()
        XCTAssertEqual(items.count, 0)
    }
    
    func testFetchWithSortAndFilter() async {
        var fileCache = FileCache()
        fileCache.modelContainer?.deleteAllData()
        fileCache = FileCache()
        
        XCTAssertNotNil(fileCache.modelContainer)
        
        var time = Date.now
        var todo1 = TodoItem(text: "test1", priority: .high, completed: true ,created: time)
        var todo2 = TodoItem(text: "test2", priority: .high, deadline: time.addingTimeInterval(200),created: time.addingTimeInterval(500))
        var todo3 = TodoItem(text: "test3", priority: .high, deadline: time, completed: true, created: time.addingTimeInterval(200))
        var todo4 = TodoItem(text: "test4", priority: .high, deadline: time.addingTimeInterval(150) , created: time.addingTimeInterval(100))
        
        await fileCache.insert(todo1)
        await fileCache.insert(todo2)
        await fileCache.insert(todo3)
        await fileCache.insert(todo4)
        
        var items = await fileCache.fetch(sort: .ascending, filter: .completed(true))
        XCTAssertEqual(items.count, 2)
        XCTAssertTrue(items[0].created < items[1].created)
        
        items = await fileCache.fetch(sort: .descending, filter: .deadline(time.addingTimeInterval(200)))
        XCTAssertEqual(items.count, 3)
        XCTAssertTrue(items[0].created > items[1].created)
        XCTAssertTrue(items[1].created > items[2].created)
    }
}
