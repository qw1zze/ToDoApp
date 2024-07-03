import SwiftUI

struct DeleteButton: View {
    @ObservedObject var viewModel: TodoItemViewModel
    @Binding var isShown: Bool
    
    var body: some View {
        Button {
            viewModel.deleteTodoItem()
            isShown = false
        } label: {
            Text("Удалить")
                .foregroundStyle(viewModel.todoItem?.id != nil ? Resources.Colors.red: Resources.Colors.Label.disable)
        }
        .frame(maxWidth: .infinity, minHeight: 20, idealHeight: 56, maxHeight: 56)
        .background(Resources.Colors.Back.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .disabled(viewModel.todoItem?.id == nil)
    }
}
