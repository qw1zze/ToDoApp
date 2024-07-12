import SwiftUI

struct TodoItemCell: View {
    var todoItem: TodoItem
    @ObservedObject var viewModel: TodoListViewModel

    private var checkCircle: some View {
        Image(todoItem.completed ? "DoneTask" : todoItem.priority == .high ? "ImportantTask" : "CheckTask")
            .frame(width: 24, height: 24)
            .onTapGesture {
                viewModel.toggleTask(todoItem)
            }
    }

    private var priorityImage: some View {
        if todoItem.priority == .high {
            return Text(Image("HighPriority"))
        } else if todoItem.priority == .low {
            return Text(Image("LowPriority"))
        }
        return Text("")
    }

    private var textTodoItem: some View {
        Text(todoItem.text)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .font(.system(size: 17))
            .foregroundStyle(todoItem.completed ? Resources.Colors.Label.disable : Resources.Colors.Label.primary)
            .strikethrough(todoItem.completed)
    }

    private func deadlineText(deadline: Date) -> some View {
        HStack(spacing: 2) {
            Image("Calendar")

            Text(deadline.formatted(date: .abbreviated, time: .omitted))
                .font(.subheadline)
        }
        .foregroundStyle(Resources.Colors.Label.secondary)
    }

    var body: some View {
        HStack(spacing: 10) {
            checkCircle

            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 2) {
                        priorityImage
                            .padding(0)

                        textTodoItem
                    }

                    if let deadline = todoItem.deadline {
                        deadlineText(deadline: deadline)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(Resources.Colors.gray)
            }
        }
        .padding([.top, .bottom], 8)
    }
}
