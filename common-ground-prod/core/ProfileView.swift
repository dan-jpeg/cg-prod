//
//  ProfileView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/17/24.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userID: authDataResult.uid)
    }
}

struct ProfileView: View {
    
    var namespace: Namespace.ID
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var menuState: MenuState
    var body: some View {
        VStack {
            
            HeaderView(namespace: namespace, squareSize: 60, menuState: $menuState)
            Spacer()
            if let user = viewModel.user{
                Text("user_id: \(user.userId)")
                
                if let email = user.email {
                    Text("email: \(email)")
                }
                
                if let  dateCreated = user.dateCreated {
                    Text("joined: \(dateCreated)")
                }
            }
            Spacer()
        }
        .task {
           try? await viewModel.loadCurrentUser()
        }
    }
}
//
//#Preview {
//    ProfileView()
//}
