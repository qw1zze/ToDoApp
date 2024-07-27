import SwiftUI
import CocoaLumberjackSwift

final class TodoListViewModel: ObservableObject {
    @Published var fileCache: FileCache
    @Published var networkingService: NetworkingService
    
    @Published var todoItems: [TodoItem]
    @Published var filterCompleted = true
    @Published var isShownTodo: Bool = false

    init(fileCache: FileCache, networkingService: NetworkingService) {
        self.fileCache = fileCache
        self.networkingService = networkingService
        self.todoItems = []
    }

    var items: [TodoItem] {
        let items: [TodoItem]
        if filterCompleted {
            items = todoItems.filter({$0.completed == false})
        } else {
            items = todoItems
        }
        return items
    }
    
    func fetchTodoItems() {
        DDLogInfo("Request: getItems")
        
        Task { @MainActor in
            do {
                if self.fileCache.getItems().isEmpty {
                    let response = try await networkingService.getList()
                    DDLogInfo("Response: \(response)")
                    
                    let items = response.list.map({ $0.toTodoItem() })
                    self.fileCache.fetchItems(items: items)
                    self.todoItems = items
                    revision = response.revision ?? 0
                    
                } else {
                    todoItems = fileCache.getItems()
                }
            } catch {
                DDLogInfo("ERROR getItems")
            }
        }
    }

    func getCompletedCount() -> Int {
        return todoItems.filter({$0.completed == true}).count
    }

    func toggleFilter() {
        filterCompleted.toggle()
    }

    func showTodo() {
        isShownTodo = true
    }

    func update(oldValue: TodoItem?, newValue: TodoItem?) {
        Task { @MainActor in
            guard let oldValue = oldValue else {
                return
            }
            if let newValue = newValue {
                
                if isDirty {
                    await updateDirty()
                }
                
                fileCache.updateTodo(newValue)
                
                do {
                    let response = try await networkingService.changeTask(by: TodoItemResponse(element: TodoItemCodable(from: newValue)), revision: revision)
                    DDLogInfo("Response: \(response)")
                    
                    for i in 0..<self.todoItems.count {
                        if self.todoItems[i].id == response.element.id {
                            self.todoItems[i] = response.element.toTodoItem()
                            break
                        }
                    }
                    
                    revision = response.revision ?? 0
                } catch {
                    DDLogInfo("ERROR changeTask")
                    isDirty = true
                    
                    for i in 0..<fileCache.getItems().count {
                        if fileCache.getItems()[i].id == newValue.id {
                            self.todoItems[i] = newValue
                            break
                        }
                    }

                }
                
            } else {
                guard let existedIndex = todoItems.firstIndex(where: { $0.id == oldValue.id}) else {
                    return
                }
                
                if isDirty {
                    await updateDirty()
                }
                
                _ = fileCache.removeTodo(id: todoItems[existedIndex].id)
                
                do {
                    let response = try await networkingService.deleteTask(by: todoItems[existedIndex].id, revision: revision)
                    DDLogInfo("Response: \(response)")
                    
                    for i in 0..<self.todoItems.count {
                        if self.todoItems[i].id == response.element.id {
                            self.todoItems.remove(at: i)
                            break
                        }
                    }
                    
                    revision = response.revision ?? 0
                } catch {
                    DDLogInfo("ERROR deletetask")
                    isDirty = true
                }
            }
        }
    }
    
    private func updateDirty() async {
        DDLogInfo("TRY SYNC DATA")
        
        do {
            let response = try await networkingService.updateList(by: TodoListResponse(list: fileCache.getItems().map({ TodoItemCodable(from: $0) })), revision: revision)
            
            DDLogInfo("SYNCED DATA WITH SERVER")
            
            let items = response.list.map({ $0.toTodoItem() })
            self.fileCache.fetchItems(items: items)
            self.todoItems = items
            revision = response.revision ?? 0
                
            isDirty = false
        } catch {
            DDLogInfo("ERROR updateList")
        }
    }

    func completeTask(_ todo: TodoItem) {
        let completedTodo = TodoItem(id: todo.id,
                                     text: todo.text,
                                     priority: todo.priority,
                                     deadline: todo.deadline,
                                     completed: true,
                                     created: todo.created,
                                     changed: todo.changed)

        self.update(oldValue: todo, newValue: completedTodo)
    }

    func uncompleteTask(_ todo: TodoItem) {
        let uncompletedTodo = TodoItem(id: todo.id,
                                     text: todo.text,
                                     priority: todo.priority,
                                     deadline: todo.deadline,
                                     completed: false,
                                     created: todo.created,
                                     changed: todo.changed)

        self.update(oldValue: todo, newValue: uncompletedTodo)
    }

    func toggleTask(_ todo: TodoItem) {
        let newTodo = TodoItem(id: todo.id,
                                     text: todo.text,
                                     priority: todo.priority,
                                     deadline: todo.deadline,
                                     completed: !todo.completed,
                                     created: todo.created,
                                     changed: todo.changed)

        self.update(oldValue: todo, newValue: newTodo)
    }

    func deleteTodo(_ todo: TodoItem) {
        self.update(oldValue: todo, newValue: nil)
    }
}
