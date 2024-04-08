//
//  NewMessageInputField.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/22/24.


import SwiftUI

struct NewMessageInputField: View {
    
    @Binding var content: String
    @State private var fieldInFocus: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(.white)   
                .stroke(.black, style: StrokeStyle())
                .frame(maxWidth: .infinity)
                .frame(height: 100)
            TextField("Type your message here", text: $content, onEditingChanged: { editingChanged in
                withAnimation {
                    self.fieldInFocus = editingChanged
                }
            })
            .foregroundColor(fieldInFocus ? .black  : .gray) // Example: Change text color when in focus
        }
    }
}

struct NewMessageInputField_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageInputField(content: .constant("new message"))
    }
}
