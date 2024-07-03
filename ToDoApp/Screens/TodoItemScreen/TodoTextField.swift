import SwiftUI

struct TodoTextField: View {
    @Binding var taskText: String
    @FocusState var onText : Bool
    
    var body: some View {
        TextEditor(text: $taskText)
            .frame(minHeight: 120)
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .scrollContentBackground(.hidden)
            .foregroundStyle(Resources.Colors.Label.primary)
            .background(Resources.Colors.Back.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .focused($onText)
    }
}
