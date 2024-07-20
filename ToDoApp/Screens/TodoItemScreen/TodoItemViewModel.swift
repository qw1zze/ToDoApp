import FileCacheUtil
import SwiftUI
import CocoaLumberjackSwift

final class TodoItemViewModel: ObservableObject {
    @Published var todoItem: TodoItem?
    @Published var taskText: String
    @Published var priority: Priority
    @Published var hasDeadline: Bool
    @Published var deadline: Date
    @Published var isShowDatePicker: Bool
    @Published var category: Category
    @Published var selectionCategory: Int = 0

    private var fileCache: FileCache<TodoItem>
    private var networkingService: NetworkingService
    private var revision: Int

    init(todoItem: TodoItem?, fileCache: FileCache<TodoItem>, networkingService: NetworkingService, revision: Int) {
        self.todoItem = todoItem
        self.taskText = todoItem?.text ?? ""
        self.priority = todoItem?.priority ?? .neutral
        self.hasDeadline = todoItem?.deadline != nil
        self.deadline = todoItem?.deadline ?? Date()
        self.isShowDatePicker = false
        self.fileCache = fileCache
        self.category = todoItem?.category ?? .other
        self.networkingService = networkingService
        self.revision = revision
        self.selectionCategory = self.category.getInt()
    }

    var hasDatePicker: Bool {
        return hasDeadline && isShowDatePicker
    }
    
    private func updateDirty() async {
        DDLogInfo("TRY SYNC DATA")
        
        await networkingService.updateList(by: TodoListResponse(list: fileCache.getItems().map({ TodoItemCodable(from: $0) })), revision: revision) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DDLogInfo("SYNC DATA WITH SERVER")
                
                DispatchQueue.main.sync {
                    let items = response.list.map({ $0.toTodoItem() })
                    self.fileCache.fetchItems(items: items)
                    self.revision = response.revision ?? 0
                    
                    isDirty = false
                }
            case .failure(let error):
                DDLogInfo("ERROR TRY SYNC DATA")
            }
        }
    }

    func saveTodoItem() {
        Task {
            let todoItem = TodoItem(id: todoItem?.id ?? UUID().uuidString,
                                    text: taskText,
                                    priority: priority,
                                    deadline: hasDeadline ? deadline : nil,
                                    completed: todoItem?.completed ?? false,
                                    created: todoItem?.created ?? Date(),
                                    changed: Date(),
                                    category: category
            )
            
            if isDirty {
                await updateDirty()
            }
            
            if fileCache.addTodo(todoItem) {
                await networkingService.addTask(by: TodoItemResponse(element: TodoItemCodable(from: todoItem)), revision: self.revision) { [weak self] result in
                    guard let self else {return}
                    
                    switch result {
                    case .success(let response):
                        DDLogInfo("GET ADD TASK RESPONSE")
                    case .failure(let error):
                        DDLogInfo("ERROR MAKING ADD DATA REQUEST")
                        
                        isDirty = true
                    }
                }
            } else {
                await networkingService.changeTask(by: TodoItemResponse(element: TodoItemCodable(from: todoItem)), revision: self.revision) { [weak self] result in
                    guard let self else {return}
                    
                    switch result {
                    case .success(let response):
                        DDLogInfo("GET UPDATE TASK RESPONSE")
                    case .failure(let error):
                        DDLogInfo("ERROR MAKING UPDATE DATA REQUEST")
                        
                        isDirty = true
                    }
                }
            }
        }
    }

    func deleteTodoItem() {
        Task {
            guard let id = todoItem?.id else {
                return
            }
            
            if isDirty {
                await updateDirty()
            }
            
            _ = fileCache.removeTodo(id: id)
            
            await networkingService.deleteTask(by: id, revision: self.revision) { [weak self] result in
                guard let self else {return}
                
                switch result {
                case .success(let response):
                    DDLogInfo("GET DELETE TASK RESPONSE")
                case .failure(let error):
                    DDLogInfo("ERROR MAKING DELETE DATA REQUEST")
                    
                    isDirty = true
                }
            }
        }
    }

    func hideDatePicker() {
        isShowDatePicker = false
    }

    func toggleDatePicker() {
        isShowDatePicker.toggle()
    }

    func changeStateDatePicker() {
        if !hasDeadline {
            isShowDatePicker = false
        } else {
            isShowDatePicker = true
        }
    }

    func setDeadlineDefault() {
        deadline = Date().addingTimeInterval(86400)
    }
}
