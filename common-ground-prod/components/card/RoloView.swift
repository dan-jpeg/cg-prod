//
//  RoloView.swift
//  common-ground
//
//  Created by dan crowley on 2/28/24.
//

import SwiftUI

@MainActor
class RolodexViewModel: ObservableObject {
    
    @Published var userID: String = ""
    @Published var selectedCard: CardFlowItem? = nil
    @Published var newConnection: Connection? = nil
    @Published var connectionId: String = ""
    @Published var fetchedConnections: [String] = []
    @Published var connectionsArray: [Connection] = []
    @Published var connectedUsers: [ConnectedUser] = []
    
    
    
    func createNewConnection() async throws {
        let userID = try AuthenticationManager.shared.getAuthenticatedUser().uid
        
        try await ConnectionManager.shared.createConnection(userId1: userID, userId2: connectionId)
        print("new connection with \(connectionId)")
        
    }
    
    func fetchConnectionStringsArray() async throws {
        let userID = try AuthenticationManager.shared.getAuthenticatedUser().uid
        self.userID = userID
        let connections = try await ConnectionManager.shared.fetchConnectionIdArrayWithUserId(userId: userID)
        self.fetchedConnections = connections
        
    }
    
    func fetchConnections() async throws {
        guard !self.fetchedConnections.isEmpty else { return }
        let connections = try await ConnectionManager.shared.fetchConnections(connectionIDs: self.fetchedConnections)
        self.connectionsArray = connections
        
    }
    func getConnectedUserInfo() async {
        guard !connectionsArray.isEmpty, !userID.isEmpty else { return }
        print(connectionsArray)

        await withTaskGroup(of: Void.self) { group in
            for connection in connectionsArray {
                group.addTask { [weak self] in
                    guard let self = self else { return }

                    // Determine the ID of the connected user based on the current user's ID
                    let connectedUserId = await (connection.userId1 == self.userID) ? connection.userId2 : connection.userId1
                    
                    do {
                        // Try to get connected user and handle potential errors within the task
                        let connectedUser = try await ConnectionManager.shared.getConnectedUser(userID: connectedUserId)
                        await MainActor.run {
                            self.connectedUsers.append(connectedUser)
                        }
                    } catch {
                        // Handle errors inside the task to avoid throwing.
                        // For example, log the error or update the UI on the main thread.
                        print("Error fetching connected user: \(error.localizedDescription)")
                    }
                }
            }
        }
        // Tasks have been handled, including their errors
        print("Finished fetching connected users.")
    }
}

enum ConnectionStage {
    case hidden, shown, pending, complete
}



struct RoloView: View {
    
    @StateObject var rolodexState = RolodexViewModel()
    
    @State private var stack: [String] = [""]
    @State private var connectionState: ConnectionStage = .hidden
    
    
    
    @Environment(\.dismiss) var dismiss
    
    @Namespace private var namespace2
 
    
    ///testing purpose only
    @State private var showConnectionCreateScreen: Bool = false
    
  
    
    var body: some View {
        ScrollView {
//            if !rolodexState.connectionsArray.isEmpty {
//                ForEach(rolodexState.connectionsArray) { connectionID in
//                    
//                    VStack(spacing: 8) {
//                        HStack(spacing: 16) {
//                            Text(connectionID.userId2)
//                                .font(.caption2)
//                                .textCase(.uppercase)
//                                .opacity(0.8)
//                            Text(connectionID.userId1)
//                                .font(.caption2)
//                                .textCase(.uppercase)
//                                .opacity(0.8)
//                        }
//                        
//                        Text(connectionID.dateCreated.description)
//                            .font(.caption2)
//                            .textCase(.uppercase)
//                            .opacity(0.8)
//                        Text("revealed: \(connectionID.connectionRevealed.description)")
//                            .font(.caption2)
//                            .textCase(.uppercase)
//                            .opacity(0.8)
//                        
//                    }
//                   
//                        
//                }
//            }
//            
//            if !rolodexState.connectedUsers.isEmpty {
//                
//                ForEach(rolodexState.connectedUsers) { user in
//                    if let city = user.city {
//                        Text(city)
//                    }
//                   
//                }
//            }
            VStack(alignment: .leading, spacing: 1) {
                
                HStack {
                    
                    
                    Button(action: {
                        dismiss()
                    } , label: {
                        LogoView(size: 50, namespace: namespace2)
                    })
                    Text("ROLODEX")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .kerning(0.1)
                    
                }
                
                Spacer(minLength: 50)
             CityCardFlow(rolodexState: rolodexState, cityName: "new york city")
          
                
               
                
                switch connectionState {
                    
                case .hidden:
                    Image(systemName: "pencil")
                        .onTapGesture {
                            connectionState = .shown
                        }
                        .font(.caption)
                        .padding(16)
                    
                case .shown:
                    
                    VStack(spacing: 2) {
                        CustomTextField(icon: "none", placeHolder: "userID:", text: $rolodexState.connectionId, isSecure: false)
                        Image(systemName: "plus.square.dashed")
                            .onTapGesture {
                                Task {
                                    connectionState = .pending
                                    try await rolodexState.createNewConnection()
                                    connectionState = .complete
                                }
                            }
                            .font(.caption)
                            .padding(16)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                case .pending:
                        Image(systemName: "plus.square.dashed")
                
                case .complete:
                    HStack(spacing: 0) {
                        Text("connection successful")
                            .font(.caption)
                            .textCase(.uppercase)
                        Image(systemName: "x.square.fill")
                            .padding(16)
                            .onTapGesture {
                                connectionState = .hidden
                            }
                            
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                  
                        
                }
                    
                
                
                
                
             
                
                            }
            
        }.padding()
            .background(
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            rolodexState.selectedCard = nil
                        }
                    }
            )
            .scrollIndicators(.hidden)
            .transition(.move(edge: .top))
            .animation(.easeInOut, value: connectionState)
            .onAppear {
                Task {
                    do {
                        try await rolodexState.fetchConnectionStringsArray()
                        try await rolodexState.fetchConnections()
                        try await rolodexState.getConnectedUserInfo()
                        print("finish fetch")
                    }
                    catch { }
                }
            }
            .onDisappear {
                Task {
                    do { try await rolodexState.fetchConnectionStringsArray() }
                    catch { }
                }
            }
    }
}

#Preview {
    RoloView()
}
