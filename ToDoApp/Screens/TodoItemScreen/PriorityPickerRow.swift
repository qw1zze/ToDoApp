import SwiftUI

struct PriorityPickerRow: View {
    @Binding var priority: Priority

    var body: some View {
        HStack {
            Text(TodoItemViewConst.priority)

            Spacer()

            PriorityPicker(priority: $priority)
        }
    }
}
