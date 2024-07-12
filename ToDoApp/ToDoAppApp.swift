import CocoaLumberjackSwift
import FileCacheUtil
import SwiftUI

@main
struct ToDoAppApp: App {
    init() {
        setupLog()
        DDLogInfo("START APP")
    }

    var body: some Scene {
        WindowGroup { // Оставил для удобства проверки
            TodoListView(viewModel: TodoListViewModel(fileCache: {
                let fileCache = FileCache<TodoItem>()
                fileCache.addTodo(TodoItem(text: "Закончить смотреть лекцию",
                                           priority: .neutral,
                                           deadline: Date().addingTimeInterval(86400 * 2),
                                           completed: false, created: Date(),
                                           changed: Date()))
                fileCache.addTodo(TodoItem(text: "Сходить в зал",
                                           priority: .neutral,
                                           deadline: Date().addingTimeInterval(86400),
                                           completed: false,
                                           created: Date(),
                                           changed: Date()))
                fileCache.addTodo(TodoItem(text: "Посидеть с друзьями",
                                           priority: .low,
                                           deadline: nil,
                                           completed: false,
                                           created: Date(),
                                           changed: Date()))
                fileCache.addTodo(TodoItem(text: "Сделать очень сложную таску с очень большим описанием и"
                                           + " очень близкм дедлайном в объеме на 3 строки",
                                           priority: .neutral,
                                           deadline: Date().addingTimeInterval(86400 * 4),
                                           completed: false,
                                           created: Date(),
                                           changed: Date()))
                fileCache.addTodo(TodoItem(text: "Купить клавиатуру",
                                           priority: .high,
                                           deadline: nil,
                                           completed: false,
                                           created: Date(),
                                           changed: Date()))
                fileCache.addTodo(TodoItem(text: "Поесть ягоды",
                                           priority: .neutral,
                                           deadline: nil,
                                           completed: false,
                                           created: Date(),
                                           changed: Date()))
                fileCache.addTodo(TodoItem(text: "Решить задачу по алгосам",
                                           priority: .neutral,
                                           deadline: Date().addingTimeInterval(86400 * 4),
                                           completed: false,
                                           created: Date(),
                                           changed: Date()))
                fileCache.addTodo(TodoItem(text: "Обновить мак",
                                           priority: .low,
                                           deadline: Date().addingTimeInterval(86400 * 4),
                                           completed: false,
                                           created: Date(),
                                           changed: Date()))
                fileCache.addTodo(TodoItem(text: "Сверстать экран на ките",
                                           priority: .high,
                                           deadline: Date().addingTimeInterval(86400),
                                           completed: true,
                                           created: Date(),
                                           changed: Date()))
                fileCache.addTodo(TodoItem(text: "Встретить друга с самолета",
                                           priority: .high,
                                           deadline: Date().addingTimeInterval(86400),
                                           completed: false,
                                           created: Date(),
                                           changed: Date()))
                fileCache.addTodo(TodoItem(text: "Поспать",
                                           priority: .high,
                                           deadline: Date().addingTimeInterval(86400 * 3),
                                           completed: false,
                                           created: Date(),
                                           changed: Date()))
                return fileCache
            }()))
        }
    }

    private func setupLog() {
        DDLog.add(DDOSLogger.sharedInstance)

        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24 * 7)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)

        dynamicLogLevel = DDLogLevel.verbose
    }
}
