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
    @FocusState var onText: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    todoTextField
                      
                    todoItemDetails
                    
                    deleteButton
                }
                .padding(16)
            }
            .animation(.easeInOut, value: viewModel.IsShowDatePicker)
            .animation(.easeInOut, value: viewModel.hasDeadline)
            .background(Resources.Colors.Back.primary)
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
                    if onText {
                        Button {
                            onText = false
                        } label: {
                            Text("Закрыть")
                        }
                    } else {
                        Button {
                            viewModel.saveTodoItem()
                            isShown = false
                        } label: {
                            Text("Сохранить")
                        }
                    }
                }
            })
        }
    }
    
    private var todoTextField: some View {
        TextEditor(text: $viewModel.taskText)
            .frame(minHeight: 120)
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .scrollContentBackground(.hidden)
            .foregroundStyle(Resources.Colors.Label.primary)
            .background(Resources.Colors.Back.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .focused($onText)
    }
    
    private var todoItemDetails: some View {
        VStack(spacing: 16) {
            priorityPickerRow
            
            Divider()
            
            deadlinePickerRow
            
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
    }
    
    private var priorityPickerRow: some View {
        HStack {
            Text("Важность")
            
            Spacer()
            
            PriorityPicker(priority: $viewModel.priority)
        }
    }
    
    private var deadlinePickerRow: some View {
        Toggle(isOn: $viewModel.hasDeadline) {
            VStack(alignment: .leading) {
                Text("Сделать до")
                    .foregroundStyle(Resources.Colors.Label.primary)
                
                if viewModel.hasDeadline {
                    Text(viewModel.deadline.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(Resources.Colors.blue)
                        .animation(.bouncy, value: viewModel.deadline)
                        .onTapGesture {
                            viewModel.IsShowDatePicker.toggle()
                        }
                }
            }
        }
        .onChange(of: viewModel.hasDeadline) {
            viewModel.changeStateDatePicker()
            viewModel.setDeadlineDefault()
        }
    }
    
    private var deleteButton: some View {
        Button {
            viewModel.deleteTodoItem()
            isShown = false
        } label: {
            Text("Удалить")
                .foregroundStyle(viewModel.todoItem?.id != nil ? Resources.Colors.red: Resources.Colors.Label.disable)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 20, idealHeight: 56, maxHeight: 56)
        .background(Resources.Colors.Back.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .disabled(viewModel.todoItem?.id == nil)
    }
}

#Preview {
    @State var show = true
    var viewModel = TodoItemViewModel(todoItem: TodoItem(text: "Example text", priority: .high, deadline: Date.now.addingTimeInterval(86400 * 4), created: Date()), fileCacheModel: FileCache())
    return TodoItemView(viewModel: viewModel, isShown: $show)
}
