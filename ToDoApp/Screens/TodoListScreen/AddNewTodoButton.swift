import SwiftUI

struct AddNewTodoButton: View {
    var action: () -> Void

    var body: some View {
        Button {
            action()
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
