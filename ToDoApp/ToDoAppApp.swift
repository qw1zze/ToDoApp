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
        WindowGroup {
            TodoListView(viewModel: TodoListViewModel(fileCache: FileCache<TodoItem>(), networkingService: DefaultNetworkingService()))
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
