//
//  MainView.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 25.06.2024.
//

import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @State private var selectedTodoItem: TodoItem?
    @State private var isTodoItemShown = false
    @State private var isTodoItemShownNew = false
    
    var body: some View {
        let _ = print(viewModel.fileCache.todoItems)
        NavigationStack {
            List {
                Section(header: HStack {
                    Text("Выполнено - \(viewModel.getCompletedCount())")
                        .textCase(.none)
                        .font(.callout)
                        .foregroundStyle(Resources.Colors.Label.secondary)
                    
                    Spacer()
                    
                    Button {
                        viewModel.filterCompleted.toggle()
                    } label: {
                        Text(viewModel.filterCompleted ? "Показать" : "Скрыть")
                            .font(.callout)
                            .foregroundStyle(Resources.Colors.blue)
                            .textCase(.none)
                            .fontWeight(.semibold)
                    }
                }) {
                    ForEach(viewModel.items) { todoItem in
                        TodoItemCell(todoItem: todoItem, viewModel: viewModel)
                            .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 0))
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    viewModel.completeTask(todoItem)
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                }
                            }
                            .tint(Resources.Colors.green)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.deleteTodo(todoItem)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                            .tint(Resources.Colors.red)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    selectedTodoItem = todoItem
                                    isTodoItemShown = true
                                } label: {
                                    Image(systemName: "info.circle")
                                }
                            }
                            .tint(Resources.Colors.grayLight)
                            .onTapGesture {
                                selectedTodoItem = todoItem
                                isTodoItemShown = true
                            }
                    }
                    Button {
                        selectedTodoItem = TodoItem(text: "", priority: .neutral, created: Date())
                        isTodoItemShownNew = true
                    } label: {
                        Text("Новое")
                            .padding(.leading, 27)
                            .padding([.top, .bottom], 10)
                            .font(.system(size: 17))
                            .foregroundStyle(Resources.Colors.Label.secondary)
                    }

                }
            }
            .animation(.easeInOut, value: viewModel.filterCompleted)

            .navigationTitle("Мои дела")
            .shadow(radius: 5)
            .overlay(alignment: .bottom) {
                Button {
                    selectedTodoItem = TodoItem(text: "", priority: .neutral, created: Date())
                    isTodoItemShownNew = true
                } label: {
                    Image(systemName: "plus")
                }
                .frame(width: 44, height: 44)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .background(.blue)
                .clipShape(Circle())
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

            }
        }
        .background(Resources.Colors.Back.primary)
        .sheet(isPresented: $isTodoItemShown) {
            TodoItemView(viewModel: TodoItemViewModel(todoItem: selectedTodoItem, update: {todoItem in
                let _ = print(123)
                viewModel.update(oldValue: selectedTodoItem, newValue: todoItem)
                selectedTodoItem = nil
            }), isShown: $isTodoItemShown)
        }
        .sheet(isPresented: $isTodoItemShownNew, onDismiss: { selectedTodoItem = nil }) {
            TodoItemView(viewModel: TodoItemViewModel(todoItem: selectedTodoItem, update: {todoItem in
                viewModel.addTodo(todoItem)
            }), isShown: $isTodoItemShownNew)
        }
    }
}

#Preview {
    TodoListView(viewModel: TodoListViewModel(fileCache: {
       let file = FileCache()
        file.addTodo(TodoItem(text: "sadasddad", priority: .neutral, created: Date()))
        return file
    }()))
}
