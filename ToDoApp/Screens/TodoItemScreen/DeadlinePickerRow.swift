import SwiftUI

struct DeadlinePickerRow: View {
    @Binding var hasDeadline: Bool
    @Binding var deadline: Date
    @ObservedObject var viewModel: TodoItemViewModel
    
    var body: some View {
        Toggle(isOn: $hasDeadline) {
            VStack(alignment: .leading) {
                Text(TodoItemViewConst.makeBefore)
                    .foregroundStyle(Resources.Colors.Label.primary)
                
                if hasDeadline {
                    Text(deadline.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(Resources.Colors.blue)
                        .animation(.bouncy, value: deadline)
                        .onTapGesture {
                            viewModel.IsShowDatePicker.toggle()
                        }
                }
            }
        }
        .onChange(of: hasDeadline) {
            viewModel.changeStateDatePicker()
            viewModel.setDeadlineDefault()
        }
    }
}
