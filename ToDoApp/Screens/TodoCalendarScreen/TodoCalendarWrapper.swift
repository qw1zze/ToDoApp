import SwiftUI
import UIKit

struct TodoCalendarWrapper: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CalendarViewModel
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return CalendarViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

#Preview {
    @State var todoItems = [TodoItem(text: "asd", priority: .high, deadline: Date(),created: Date()),
    
                            TodoItem(text: "asd", priority: .high, deadline: Date(),created: Date()),
                            TodoItem(text: "asd", priority: .high, deadline: Date().addingTimeInterval(86400*4),created: Date())]
    return TodoCalendarWrapper(viewModel: CalendarViewModel(fileCache: {
        let file = FileCacheLocal()
        file.addTodo(TodoItem(text: "asd", priority: .high, deadline: Date(),created: Date(), category: .hobby))
        file.addTodo(TodoItem(text: "asd", priority: .high, deadline: Date().addingTimeInterval(86400 * 4),created: Date()))
        file.addTodo(TodoItem(text: "asd", priority: .high, deadline: Date().addingTimeInterval(86400),created: Date()))
        file.addTodo(TodoItem(text: "asd", priority: .high, deadline: Date().addingTimeInterval(86400),created: Date()))
        file.addTodo(TodoItem(text: "asd", priority: .high, deadline: Date().addingTimeInterval(86400 * 3),created: Date()))
        file.addTodo(TodoItem(text: "asd", priority: .high, deadline: Date().addingTimeInterval(86400),created: Date()))
        file.addTodo(TodoItem(text: "asd", priority: .high, deadline: Date().addingTimeInterval(86400),created: Date()))
        file.addTodo(TodoItem(text: "asd", priority: .high, deadline: Date(),created: Date()))
        file.addTodo(TodoItem(text: "asd", priority: .high, deadline: Date().addingTimeInterval(86400),created: Date()))
        file.addTodo(TodoItem(text: "asd", priority: .high, deadline: Date().addingTimeInterval(86400),created: Date()))
        return file
    }()))
}
