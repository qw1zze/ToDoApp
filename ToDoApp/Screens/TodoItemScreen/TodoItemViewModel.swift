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

    private var fileCache: FileCache
    private var networkingService: NetworkingService

    init(todoItem: TodoItem?, fileCache: FileCache, networkingService: NetworkingService) {
        self.todoItem = todoItem
        self.taskText = todoItem?.text ?? ""
        self.priority = todoItem?.priority ?? .neutral
        self.hasDeadline = todoItem?.deadline != nil
        self.deadline = todoItem?.deadline ?? Date()
        self.isShowDatePicker = false
        self.fileCache = fileCache
        self.category = todoItem?.category ?? .other
        self.networkingService = networkingService
        self.selectionCategory = self.category.getInt()
    }

    var hasDatePicker: Bool {
        return hasDeadline && isShowDatePicker
    }
    
    private func updateDirty() async {
        DDLogInfo("TRY SYNC DATA")
        
        do {
            let response = try await networkingService.updateList(by: TodoListResponse(list: fileCache.getItems().map({ TodoItemCodable(from: $0) })), revision: revision)
            DDLogInfo("SYNCED DATA WITH SERVER")
            
            let items = response.list.map({ $0.toTodoItem() })
            self.fileCache.fetchItems(items: items)
            revision = response.revision ?? 0
                
            isDirty = false
        } catch {
            DDLogInfo("ERROR updateList")
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
                do {
                    var _ = try await networkingService.addTask(by: TodoItemResponse(element: TodoItemCodable(from: todoItem)), revision: revision)
                    DDLogInfo("ADDED TASK")
                } catch {
                    DDLogInfo("ERROR addTask")
                    
                    isDirty = true
                }
            } else {
                do {
                    _ = try await networkingService.changeTask(by: TodoItemResponse(element: TodoItemCodable(from: todoItem)), revision: revision)
                    DDLogInfo("UPDATED TASK")
                    
                } catch {
                    DDLogInfo("ERROR changeTask")
                    isDirty = true
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
            
            do {
                _ = try await networkingService.deleteTask(by: id, revision: revision)
                DDLogInfo("DELETED TASK")
            } catch {
                DDLogInfo("ERROR deleteTask")
                isDirty = true
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
