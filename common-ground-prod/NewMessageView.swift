import SwiftUI

struct NewMessageView: View {
    @Environment(\.presentationMode) var presentationMode
    var recipient: ConnectedUser // Assuming you're passing the recipient's user details
    
    @State private var messageText: String = ""
    @State private var isSending: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Send a message to \(recipient.firstName ?? "User")")
                    .font(.headline)
                    .padding()
                
                TextField("Write your message here...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    
                }) {
                    Text(isSending ? "Sending..." : "Send")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                .disabled(isSending || messageText.isEmpty)
            }
            .navigationBarTitle("New Message", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    
}

