import FileCacheUtil
import SwiftUI
import CocoaLumberjackSwift

final class TodoListViewModel: ObservableObject {
    @Published var fileCache: FileCache<TodoItem>
    @Published var networkingService: NetworkingService
    
    @Published var todoItems: [TodoItem]
    @Published var filterCompleted = true
    @Published var isShownTodo: Bool = false
    
    private var revision: Int = 0

    init(fileCache: FileCache<TodoItem>, networkingService: NetworkingService) {
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
        Task {
            await networkingService.getList() { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    DDLogInfo("GET TASKS LIST RESPONSE")
                    DispatchQueue.main.sync {
                        let items = response.list.map({ $0.toTodoItem() })
                        self.fileCache.fetchItems(items: items)
                        self.todoItems = items
                        self.revision = response.revision ?? 0
                    }
                case .failure(let error):
                    DDLogInfo("ERROR MAKING TASK LIST REQUEST")
                }
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
        Task {
            guard let oldValue = oldValue else {
                return
            }
            if let newValue = newValue {
                
                if isDirty {
                    await updateDirty()
                }
                
                await networkingService.changeTask(by: TodoItemResponse(element: TodoItemCodable(from: newValue)), revision: revision) { [weak self] result in
                    guard let self = self else { return }
                    
                    fileCache.updateTodo(newValue)
                    switch result {
                    case .success(let response):
                        DDLogInfo("GET UPDATE TASK RESPONSE")
                        
                        DispatchQueue.main.sync {
                            for i in 0..<self.todoItems.count {
                                if self.todoItems[i].id == response.element.id {
                                    self.todoItems[i] = response.element.toTodoItem()
                                    break
                                }
                            }
                            
                            self.revision = response.revision ?? 0
                        }
                    case .failure(let error):
                        DDLogInfo("ERROR MAKING UPDATE TASK REQUESTS")
                        isDirty = true
                    }
                }
            } else {
                guard let existedIndex = todoItems.firstIndex(where: { $0.id == oldValue.id}) else {
                    return
                }
                
                if isDirty {
                    await updateDirty()
                }
                
                await networkingService.deleteTask(by: todoItems[existedIndex].id, revision: revision) {[weak self] result in
                    guard let self = self else { return }
                    
                    _ = fileCache.removeTodo(id: todoItems[existedIndex].id)
                    
                    switch result {
                    case .success(let response):
                        DDLogInfo("GET DELETE TASK RESPONSE")
                        
                        DispatchQueue.main.sync {
                            for i in 0..<self.todoItems.count {
                                if self.todoItems[i].id == response.element.id {
                                    self.todoItems.remove(at: i)
                                    break
                                }
                            }
                            
                            self.revision = response.revision ?? 0
                        }
                    case .failure(let error):
                        DDLogInfo("ERROR MAKING DELETE TASK REQUEST")
                        isDirty = true
                    }
                }
            }
        }
    }
    
    private func updateDirty() async {
        DDLogInfo("TRY SYNC DATA")
        
        await networkingService.updateList(by: TodoListResponse(list: self.todoItems.map({ TodoItemCodable(from: $0) })), revision: revision) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DDLogInfo("SYNC DATA WITH SERVER")
                
                DispatchQueue.main.sync {
                    let items = response.list.map({ $0.toTodoItem() })
                    self.fileCache.fetchItems(items: items)
                    self.todoItems = items
                    self.revision = response.revision ?? 0
                    
                    isDirty = false
                }
            case .failure(let error):
                DDLogInfo("ERROR TRY SYNC DATA")
            }
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
