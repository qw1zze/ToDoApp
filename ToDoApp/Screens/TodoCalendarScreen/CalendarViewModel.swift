import Foundation

final class CalendarViewModel: ObservableObject {
    @Published var fileCache: FileCache
    @Published var todoItems: [TodoItem]
    @Published var source: [CalendarTodoItem]
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
        self.todoItems = fileCache.todoItems
        self.source = CalendarViewModel.convertSource(fileCache.todoItems)
    }
    
    func completeTask(_ todo: TodoItem) -> TodoItem {
        let completedTodo = TodoItem(id: todo.id,
                                     text: todo.text,
                                     priority: todo.priority,
                                     deadline: todo.deadline,
                                     completed: true,
                                     created: todo.created,
                                     changed: todo.changed,
                                     category: todo.category)
        fileCache.updateTodo(completedTodo)
        self.todoItems = fileCache.todoItems
        return completedTodo
    }
    
    func uncompleteTask(_ todo: TodoItem) -> TodoItem {
        let uncompletedTodo = TodoItem(id: todo.id,
                                     text: todo.text,
                                     priority: todo.priority,
                                     deadline: todo.deadline,
                                     completed: false,
                                     created: todo.created,
                                     changed: todo.changed,
                                     category: todo.category)
        fileCache.updateTodo(uncompletedTodo)
        self.todoItems = fileCache.todoItems
        return uncompletedTodo
    }
    
    func updateItems() {
        self.source = CalendarViewModel.convertSource(self.fileCache.todoItems)
    }
    
    static func convertSource(_ items: [TodoItem]) -> [CalendarTodoItem] {
        let months = [
            "Jan": 1,
            "Feb": 2,
            "Mar": 3,
            "Apr": 4,
            "May": 5,
            "Jun": 6,
            "Jul": 7,
            "Aug": 8,
            "Sep": 9,
            "Oct": 10,
            "Nov": 11,
            "Dec": 12
        ]
        
        var source = [CalendarTodoItem]()
        items.forEach { item in
            guard let deadline = item.deadline else {
                if let ind = source.firstIndex(where: { $0.day == TodoCalendarViewConst.other }) {
                    source[ind].todoItems.append(item)
                } else {
                    source.append(CalendarTodoItem(day: TodoCalendarViewConst.other, month: "", todoItems: [item]))
                }
                return
            }
            
            if let ind = source.firstIndex(where: { $0.day == deadline.getDayAndMonth().0 && $0.month == deadline.getDayAndMonth().1 }) {
                source[ind].todoItems.append(item)
            } else {
                source.append(CalendarTodoItem(day: deadline.getDayAndMonth().0, month: deadline.getDayAndMonth().1, todoItems: [item]))
            }
        }
        
        source.sort { first, second in
            let firstMonth = months[first.month] ?? 0
            let secondMonth = months[second.month] ?? 0
            if firstMonth < secondMonth {
                return true
            } else if firstMonth > secondMonth {
                return false
            }
            return first.day < second.day
        }

        if let ind = source.firstIndex(where: { $0.day == TodoCalendarViewConst.other }) {
            let item = source[ind]
            source.remove(at: ind)
            source.append(item)
        }
        return source
    }
}
