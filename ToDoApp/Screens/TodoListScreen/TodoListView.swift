import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @State var selectedTodo: TodoItem?
    
    private var completedTasksFilter: some View {
        HStack {
            Text("Выполнено - \(viewModel.getCompletedCount())")
                .textCase(.none)
                .font(.callout)
                .foregroundStyle(Resources.Colors.Label.secondary)
            
            Spacer()
            
            Button {
                viewModel.toggleFilter()
            } label: {
                Text(viewModel.filterCompleted ? "Показать" : "Скрыть")
                    .font(.callout)
                    .foregroundStyle(Resources.Colors.blue)
                    .textCase(.none)
                    .fontWeight(.semibold)
            }
        }
        .padding(.horizontal, -6)
    }
    
    private var newTodoRowButton: some View {
        Button {
            viewModel.showTodo()
        } label: {
            Text("Новое")
                .padding(.leading, 33)
                .padding([.top, .bottom], 10)
                .font(.system(size: 17))
                .foregroundStyle(Resources.Colors.Label.secondary)
        }
        .listRowBackground(Resources.Colors.Back.secondary)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section(header: completedTasksFilter)
                    {
                        ForEach(viewModel.items) { todoItem in
                           TodoItemCell(todoItem: todoItem, viewModel: viewModel)
                                .listRowBackground(Resources.Colors.Back.secondary)
                                .onTapGesture {
                                    selectedTodo = todoItem
                                    viewModel.showTodo()
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        viewModel.toggleTask(todoItem)
                                    } label: {
                                        Image(systemName: todoItem.completed ? "xmark.circle": "checkmark.circle")
                                    }
                                    .tint(todoItem.completed ? Resources.Colors.red : Resources.Colors.green)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.deleteTodo(todoItem)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(Resources.Colors.red)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        selectedTodo = todoItem
                                        viewModel.showTodo()
                                    } label: {
                                        Image(systemName: "info.circle")
                                    }
                                }
                        }

                        newTodoRowButton
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Мои дела")
                .overlay(alignment: .bottom) {
                    AddNewTodoButton(action: viewModel.showTodo)
                }
            }
            .background(Resources.Colors.Back.primary)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Calendar") {
                        TodoCalendarWrapper(todoItems: $viewModel.todoItems)
                            .navigationTitle("Мои дела")
                            .toolbarRole(.editor)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }
        }
        .background(Resources.Colors.Back.primary)
        .sheet(isPresented: $viewModel.isShownTodo, onDismiss: { selectedTodo = nil; viewModel.update() }) {
            TodoItemView(viewModel: TodoItemViewModel(todoItem: selectedTodo, fileCache: viewModel.fileCache), isShown: $viewModel.isShownTodo)
        }
    }
}

#Preview {
    let file = FileCacheLocal()
    file.addTodo(TodoItem(text: "sadasddad", priority: .high, created: Date()))
    file.addTodo(TodoItem(text: "Ssssssss", priority: .neutral, deadline: Date(), created: Date()))
    return TodoListView(viewModel: TodoListViewModel(fileCache: file))
}
