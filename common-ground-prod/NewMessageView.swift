import SwiftUI

struct NewMessageView: View {
    
//    var recipient: ConnectedUser // Assuming you're passing the recipient's user details
    
    @State private var messageText: String = ""
    @State private var isSending: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Send a message ..")
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
        }
    }
    
    
}

#Preview {
    NewMessageView()
}

