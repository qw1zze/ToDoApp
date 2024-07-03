import SwiftUI

struct PriorityPickerRow: View {
    @Binding var priority: Priority
    
    var body: some View {
        HStack {
            Text("Важность")
            
            Spacer()
            
            PriorityPicker(priority: $priority)
        }
    }
}
