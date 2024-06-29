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
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: HStack {
                    Text("Выполнено - nil")
                        .textCase(.none)
                        .font(.callout)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Показать")
                            .font(.callout)
                            .textCase(.none)
                            .fontWeight(.semibold)
                    }
                }) {
                    ForEach(viewModel.fileCache.todoItems) { todoItem in
                        TodoItemCell(todoItem: todoItem)
                            .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 0))
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    //Todo
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                }
                            }
                            .tint(Resources.Colors.green)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    //Todo
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                            .tint(Resources.Colors.red)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    //TODO
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
                }
            }
            .navigationTitle("Мои дела")
            .shadow(radius: 5)
            .overlay(alignment: .bottom) {
                Button {
                    selectedTodoItem = TodoItem(text: "", priority: .neutral, created: Date())
                    isTodoItemShown = true
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
        .sheet(isPresented: $isTodoItemShown, onDismiss: { selectedTodoItem = nil }) {
            TodoItemView(viewModel: TodoItemViewModel(todoItem: selectedTodoItem, fileCacheModel: viewModel.fileCache), isShown: $isTodoItemShown)
        }
    }
}

#Preview {
    TodoListView(viewModel: TodoListViewModel(fileCache: FileCache()))
}
