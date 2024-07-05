import SwiftUI
import UIKit

struct TodoCalendarWrapper: UIViewControllerRepresentable {
    @Binding var todoItems: [TodoItem]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return CalendarViewController(source: convertSource(todoItems))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func convertSource(_ items: [TodoItem]) -> [((String, String), [String])] {
        var source = [((String, String), [String])]()
        items.forEach { item in
            guard let deadline = item.deadline else {
                if let ind = source.firstIndex(where: { $0.0.0 == "Другое" }) {
                    source[ind].1.append(item.text)
                } else {
                    source.append((("Другое", ""), [item.text]))
                }
                return
            }
            
            if let ind = source.firstIndex(where: { $0.0.0 == deadline.getDayAndMonth().0 && $0.0.1 == deadline.getDayAndMonth().1 }) {
                source[ind].1.append(item.text)
            } else {
                source.append(((deadline.getDayAndMonth().0, deadline.getDayAndMonth().1), [item.text]))
            }
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
    return TodoCalendarWrapper(todoItems: $todoItems)
}
