import SwiftUI

struct PriorityPicker: View {
    @Binding var priority: Priority

    var body: some View {
        Picker("Priority", selection: $priority) {
            Image(TodoItemViewConst.priorotyOptions[0])
                .tag(Priority.low)

            Text(TodoItemViewConst.priorotyOptions[1])
                .foregroundStyle(Resources.Colors.Label.primary)
                .tag(Priority.neutral)

            Image(TodoItemViewConst.priorotyOptions[2])
                .tag(Priority.high)
        }
        .pickerStyle(.segmented)
        .frame(width: 150)
        .labelsHidden()
    }
}
#Preview(body: {
    @State var priority: Priority = .high
    return PriorityPicker(priority: $priority)
})
