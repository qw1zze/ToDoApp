import SwiftUI

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

    init(todoItem: TodoItem?, fileCache: FileCache) {
        self.todoItem = todoItem
        self.taskText = todoItem?.text ?? ""
        self.priority = todoItem?.priority ?? .neutral
        self.hasDeadline = todoItem?.deadline != nil
        self.deadline = todoItem?.deadline ?? Date()
        self.isShowDatePicker = false
        self.fileCache = fileCache
        self.category = todoItem?.category ?? .other
        self.selectionCategory = self.category.getInt()
    }

    var hasDatePicker: Bool {
        return hasDeadline && isShowDatePicker
    }

    func saveTodoItem() {
        let todoItem = TodoItem(id: todoItem?.id ?? UUID().uuidString,
                                text: taskText,
                                priority: priority,
                                deadline: hasDeadline ? deadline : nil,
                                completed: todoItem?.completed ?? false,
                                created: todoItem?.created ?? Date(),
                                changed: Date(),
                                category: category
        )
        fileCache.addTodo(todoItem)
    }

    func deleteTodoItem() {
        guard let id = todoItem?.id else {
            return
        }
        _ = fileCache.removeTodo(id: id)
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
