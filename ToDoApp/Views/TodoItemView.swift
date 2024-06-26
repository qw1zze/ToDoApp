//
//  TodoItemView.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 25.06.2024.
//

import SwiftUI

struct TodoItemView: View {
    @ObservedObject var viewModel: TodoItemViewModel
    @Binding var isShown: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    TodoItemTextField(taskText: $viewModel.taskText)
                    
                    TodoItemDetails(prioity: $viewModel.prioity, hasDeadline: $viewModel.hasDeadline, deadline: $viewModel.deadline)
                    
                    todoItemDeleteButton(viewModel: viewModel, isShown: $isShown)
                }
                .padding(16)
            }
            .background(.thickMaterial)
            .animation(.easeOut, value: viewModel.hasDeadline)
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShown = false
                    } label: {
                        Text("Отменить")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.saveTodoItem()
                        isShown = false
                    } label: {
                        Text("Сохранить")
                    }
                }
            })
        }
    }
}

#Preview {
    @State var hasDeadliine = true
    var viewModel = TodoItemViewModel(todoItem: TodoItem(text: "Example text", priority: .high, deadline: Date.now.addingTimeInterval(86400 * 4), created: Date()), fileCacheModel: FileCache())
    return TodoItemView(viewModel: viewModel, isShown: $hasDeadliine)
}

struct TodoItemTextField: View {
    @Binding var taskText: String
    
    var body: some View {
        TextEditor(text: $taskText)
            .frame(minHeight: 120)
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(.windowBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct TodoItemDetails: View {
    @Binding var prioity: Priority
    @Binding var hasDeadline: Bool
    @Binding var deadline: Date
    
    var body: some View {
        VStack(spacing: 16) {
            PriorityPicker(priority: $prioity)
            
            Divider()
            
            todoItemDeadline(hasDeadline: $hasDeadline, deadline: $deadline)
            
            if hasDeadline {
                Divider()
                
                DatePicker("", selection: $deadline, in: Date.now..., displayedComponents: [.date])
                    .datePickerStyle(.graphical)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct PriorityPicker: View {
    @Binding var priority: Priority
    
    var body: some View {
        HStack {
            Text("Важность")
            
            Spacer()
            
            Picker("Priority", selection: $priority) {
                Image(systemName: "arrow.down")
                    .tag(Priority.low)
                
                Text("нет")
                    .tag(Priority.neutral)
                
                Image(systemName: "exclamationmark.2")
                    .tag(Priority.high)
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .frame(width: 150)
        }
    }
}

struct todoItemDeadline: View {
    @Binding var hasDeadline: Bool
    @Binding var deadline: Date
    
    var body: some View {
        Toggle(isOn: $hasDeadline) {
            VStack(alignment: .leading) {
                Text("Сделать до")
                
                if hasDeadline {
                    Text(deadline.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}

struct todoItemDeleteButton: View {
    @ObservedObject var viewModel: TodoItemViewModel
    @Binding var isShown: Bool
    
    var body: some View {
        Button {
            viewModel.deleteTodoItem()
            isShown = false
        } label: {
            Text("Удалить")
                .foregroundStyle(.red)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 20, idealHeight: 56, maxHeight: 56)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .disabled(viewModel.todoItem?.id == nil)
    }
}
