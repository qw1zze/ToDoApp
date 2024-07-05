import SwiftUI

protocol updateListDelegate {
    func update()
}

struct TodoItemView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TodoItemViewModel
    @FocusState var onText: Bool
    
    var delegate: updateListDelegate?
    
    @ViewBuilder private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Отменить")
        }
    }
    
    @ViewBuilder private var saveButton: some View {
        if onText {
            Button {
                onText = false
            } label: {
                Text("Закрыть")
            }
        } else {
            Button {
                if viewModel.taskText != "" {
                    viewModel.saveTodoItem()
                    delegate?.update()
                    dismiss()
                }
            } label: {
                Text("Сохранить")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    TodoTextField(taskText: $viewModel.taskText, onText: _onText)
                      
                    VStack(spacing: 16) {
                        
                        PriorityPickerRow(priority: $viewModel.priority)
                        
                        Divider()
                        
                        DeadlinePickerRow(hasDeadline: $viewModel.hasDeadline, deadline: $viewModel.deadline, viewModel: viewModel)
                            
                        if viewModel.hasDatePicker {
                            Divider()
                            
                            DatePicker("", selection: $viewModel.deadline, in: Date.now..., displayedComponents: [.date])
                                .datePickerStyle(.graphical)
                                .onChange(of: viewModel.deadline) {
                                    viewModel.hideDatePicker()
                                }
                            }
                        
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                    .foregroundStyle(Resources.Colors.Label.primary)
                    .background(Resources.Colors.Back.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    DeleteButton(viewModel: viewModel)
                }
                .padding(16)
            }  
            .animation(.easeInOut, value: viewModel.hasDatePicker)
            .background(Resources.Colors.Back.primary)
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            })
        }
    }
}

#Preview {
    @State var show = true
    let viewModel = TodoItemViewModel(todoItem: nil, fileCache: FileCacheLocal())
    return TodoItemView(viewModel: viewModel, delegate: nil)
}
