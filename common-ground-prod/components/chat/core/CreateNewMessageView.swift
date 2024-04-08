//
//  CreateNewMessageView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/28/24.
//

import SwiftUI

@MainActor
final class NewMessageViewModel: ObservableObject {
    @Published var users: [DBUser] = []
    @Published var errorMessage: String = ""
    
    
     func fetchAllUsers() async throws {
        self.users = try await UserManager.shared.fetchAllUsers()
    }
    
}

struct NewMessageRow: View {
    var user: DBUser
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text(user.email ?? "No Email") // Safely unwrap the email
                        .font(.subheadline)
                    Text(user.city ?? "No City") // Safely unwrap the city
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .textCase(.uppercase)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
        }
    }
}

struct CreateNewMessageView: View {
    @StateObject private var viewModel = NewMessageViewModel()
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.users, id: \.userId) { user in
                NewMessageRow(user: user) {
                    // Here you would define the action to create a new conversation
                    createNewConversation(with: user)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.horizontal, 15)
        .onAppear {
            Task {
                try await viewModel.fetchAllUsers()
            }
        }
    }
    
    private func createNewConversation(with user: DBUser) {
        // Implement your logic to create a new conversation with the selected user
        print("Creating conversation with user: \(user.userId)")
    }
}

// SwiftUI Preview Environment
struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageView()
    }
}
