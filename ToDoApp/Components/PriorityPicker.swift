//
//  PriorityPicker.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 28.06.2024.
//

import SwiftUI

struct PriorityPicker: View {
    @Binding var priority: Priority
    
    var body: some View {
        Picker("Priority", selection: $priority) {
            Image("Arrow.down")
                .tag(Priority.low)
            
            Text("нет")
                .foregroundStyle(Resources.Colors.Label.primary)
                .tag(Priority.neutral)
            
            Image("HighPriority")
                .tag(Priority.high)
        }
        .pickerStyle(.segmented)
        .frame(width: 150)
        .labelsHidden()
    }
}
#Preview(body: {
    @State var priority: Priority = .high
    return PriorityPicker(priority: $priority)
})
