import CocoaLumberjackSwift
import FileCacheUtil
import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @State var selectedTodo: TodoItem?

    private var completedTasksFilter: some View {
        HStack {
            Text("\(TodoListViewConst.completed) - \(viewModel.getCompletedCount())")
                .textCase(.none)
                .font(.callout)
                .foregroundStyle(Resources.Colors.Label.secondary)

            Spacer()

            Button {
                viewModel.toggleFilter()
            } label: {
                Text(viewModel.filterCompleted ? TodoListViewConst.show : TodoListViewConst.hide)
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
            Text(TodoListViewConst.new)
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
                    Section(header: completedTasksFilter) {
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
                                        Image(systemName: todoItem.completed ? "xmark.circle" : "checkmark.circle")
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
                .onAppear {
                    viewModel.fetchTodoItems()
                }
            }
            .background(Resources.Colors.Back.primary)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        TodoCalendarWrapper(viewModel: CalendarViewModel(fileCache: viewModel.fileCache, networkingService: viewModel.networkingService))
                            .navigationTitle(TodoListViewConst.myTasks)
                            .navigationBarTitleDisplayMode(.inline)
                            .background(Resources.Colors.Back.primary.edgesIgnoringSafeArea(.bottom))
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }
        }
        .background(Resources.Colors.Back.primary)
        .sheet(isPresented: $viewModel.isShownTodo, onDismiss: { selectedTodo = nil; viewModel.fetchTodoItems() }, content: {
            TodoItemView(viewModel: TodoItemViewModel(todoItem: selectedTodo, fileCache: viewModel.fileCache, networkingService: viewModel.networkingService))
        })
        .onAppear {
            DDLogInfo("OPENING TODOITEM LIST VIEW")
            viewModel.fetchTodoItems()
        }
    }
}

#Preview {
    let file = FileCache<TodoItem>()
    return TodoListView(viewModel: TodoListViewModel(fileCache: file, networkingService: DefaultNetworkingService()))
}
