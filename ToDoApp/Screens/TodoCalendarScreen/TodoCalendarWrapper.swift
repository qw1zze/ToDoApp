import SwiftUI
import UIKit

struct TodoCalendarWrapper: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CalendarViewModel
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return CalendarViewController(source: convertSource(viewModel.todoItems), viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func convertSource(_ items: [TodoItem]) -> [((String, String), [TodoItem])] {
        var source = [((String, String), [TodoItem])]()
        items.forEach { item in
            guard let deadline = item.deadline else {
                if let ind = source.firstIndex(where: { $0.0.0 == "Другое" }) {
                    source[ind].1.append(item)
                } else {
                    source.append((("Другое", ""), [item]))
                }
                return
            }
            
            if let ind = source.firstIndex(where: { $0.0.0 == deadline.getDayAndMonth().0 && $0.0.1 == deadline.getDayAndMonth().1 }) {
                source[ind].1.append(item)
            } else {
                source.append(((deadline.getDayAndMonth().0, deadline.getDayAndMonth().1), [item]))
            }
        }
        source.sort { first, second in
            first.0.0 < second.0.0
        }
        if let ind = source.firstIndex(where: { $0.0.0 == "Другое" }) {
            let item = source[ind]
            source.remove(at: ind)
            source.append(item)
        }
        return source
    }
}

#Preview {
    @State var todoItems = [TodoItem(text: "asd", priority: .high, deadline: Date(),created: Date()),
    
                            TodoItem(text: "asd", priority: .high, deadline: Date(),created: Date()),
                            TodoItem(text: "asd", priority: .high, deadline: Date().addingTimeInterval(86400*4),created: Date())]
    return TodoCalendarWrapper(viewModel: CalendarViewModel(fileCache: {
        let file = FileCacheLocal()
        file.addTodo(TodoItem(text: "asd", priority: .high, deadline: Date(),created: Date()))
        return file
    }()))
}
