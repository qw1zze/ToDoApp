import SwiftUI

struct DeleteButton: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TodoItemViewModel
    
    var body: some View {
        Button {
            viewModel.deleteTodoItem()
            dismiss()
        } label: {
            Text(TodoItemViewConst.delete)
                .foregroundStyle(viewModel.todoItem?.id != nil ? Resources.Colors.red: Resources.Colors.Label.disable)
        }
        .frame(maxWidth: .infinity, minHeight: 20, idealHeight: 56, maxHeight: 56)
        .background(Resources.Colors.Back.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .disabled(viewModel.todoItem?.id == nil)
    }
}
