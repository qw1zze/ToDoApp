//
//  TodoItemCell.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 29.06.2024.
//

import SwiftUI

struct TodoItemCell: View {
    var todoItem: TodoItem
    @ObservedObject var viewModel: TodoListViewModel
    
    private var checkCircle: some View {
        Image(todoItem.completed ? "DoneTask": todoItem.priority == .high ? "ImportantTask" : "CheckTask")
            .frame(width: 24, height: 24)
            .onTapGesture {
                viewModel.toggleTask(todoItem)
            }
    }
    
    private var priorityImage: some View {
        if todoItem.priority == .high {
            return Text(Image("HighPriority"))
        } else if todoItem.priority == .low {
            return Text(Image("LowPriority"))
        }
        return Text("")
    }
    
    var body: some View {
        HStack(spacing: 10) {
            checkCircle
            
            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    priorityImage
                        .padding(0)
                    
                    Text(todoItem.text)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 17))
                        .foregroundStyle(todoItem.completed ? Resources.Colors.Label.disable: Resources.Colors.Label.primary)
                        .strikethrough(todoItem.completed)
                }
                
                if let deadline = todoItem.deadline {
                    HStack(spacing: 2) {
                        Image("Calendar")
                        
                        Text(deadline.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                    }
                    .foregroundStyle(Resources.Colors.Label.secondary)
                }
            }
            .animation(.easeInOut, value: todoItem.completed)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Resources.Colors.gray)
            
            Color(.blue) //TODO
                .frame(width: 5)
                .padding([.top, .bottom], -12)
        }
        .padding([.top, .bottom], 8)
    }
}
