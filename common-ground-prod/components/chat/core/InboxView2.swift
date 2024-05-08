//
//  InboxView2.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/22/24.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting

@MainActor
final class InboxViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var user: DBUser? = nil
    @Published var conversations: [Conversation] = []
    @Published var newConverastionID: String = ""
    @Published var partnerNames: [String : String] = [:]
    
    
    
    
    func loadCurrentUser() async throws {
        
         let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
         self.user = try await UserManager.shared.getUser(userID: authUser.uid)
    }
    func loadConversations() async {
           guard let userId = self.user?.userId else {
               self.errorMessage = "User ID is unavailable."
               return
           }
           
           do {
               let fetchedConversations = try await ChatManager.shared.fetchConversations(userId: userId)
               self.conversations = fetchedConversations
               print(conversations)
               for conversation in self.conversations {
                      if let partnerId = conversation.participants.first(where: { $0.key != self.user?.userId })?.key,
                         let partnerName = conversation.participants[partnerId] {
                          self.partnerNames[conversation.id ?? ""] = partnerName
                      }
                  }
           } catch {
               self.errorMessage = "Failed to load conversations: \(error.localizedDescription)"
           }
       }
    
    func createConversation(user2: String) async throws -> String {
        
        guard let userID = self.user?.userId else { return "" }
        
        let userArray = [userID, user2]
        let newConversation = try await ChatManager.shared.createConversation(userIDs: userArray)
        self.conversations.append(newConversation)
        guard let id = newConversation.id else { return "" }
        return id
    }
    
    func postNewMessage(conversationId: String, text: String) async throws {
        
     
        guard let user = self.user else {
            print("User is not loaded")
            return
        }
        
        let newMessage = Message(senderId: user.userId, recipientId: "0fGsIGAan8f0uNHQWdEARO2Y8PJ2", // You might want to adjust this according to your design
                                 text: text, timestamp: Date(), favorite: false)
        
        print(newMessage.text)
        
        do {
            try await ChatManager.shared.postMessage(conversationId: conversationId, message: newMessage)
            // Assuming success, add the message to the local messages array to update UI
        } catch {
            self.errorMessage = "Failed to post new message: \(error.localizedDescription)"
        }
    }
   }
    

struct InboxView2: View {
    
    @StateObject private var viewModel = InboxViewModel()
    
    @Binding var menuState: MenuState
    var namespace: Namespace.ID
    @State private var isChatViewPresented = false
    @State private var isNewMessageViewPresented: Bool = false
    @State private var selectedConversationId: String? = nil
    @State private var selectedUserId: String? = nil
    @State private var selectedPartnerId: String? = nil
    @State private var selectedPartnerName: String? = nil
    
    @State private var showUserId: Bool = false
    
    @Environment(\.router) var router
    
    
    var body: some View {
        ZStack {
            if isChatViewPresented, let conversationId = selectedConversationId, let userId = selectedUserId, let partnerId = selectedPartnerId, let partnerName = selectedPartnerName {
                            // Pass the selectedConversationId and userId to the ChatView
                ChatView(conversationId: conversationId, userId: userId, partnerId: partnerId, partnerName: partnerName, isChatViewPresented: $isChatViewPresented, menuState: $menuState, namespace: namespace)
                                .padding(.horizontal, 20)
                                .onDisappear {
                                    // Reset the selectedConversationId when ChatView is dismissed
                                    selectedConversationId = nil
                                    selectedUserId = nil
                                    selectedPartnerId = nil
                                    selectedPartnerName = nil
                                }
                        } else {
                VStack {
                    HStack{
                        
                        LogoView(size: 30, namespace: namespace)
                        
                            .offset(x: -20)
                        Spacer()
                        VStack {
                            Text("CO")
                            Text("GR")
                        }
                        .matchedGeometryEffect(id: "logotext", in: namespace)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                        .opacity(0.9)
                        .font(.system(size: 19))
                        .offset(y: 5)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            menuState = .welcome
                        }
                    }
                    .padding(30)
                    if viewModel.user != nil {
                        VStack {
                            HStack {
                                if showUserId  {
                                    Text("\(viewModel.user!.userId)")
                                        .font(.caption2)
                                } else {
                                    Image(systemName: "info.circle.fill")
                                        .font(.caption2)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            .padding(.horizontal, 48)
                            .fontWeight(.medium)
                            .onTapGesture {
                                showUserId.toggle()
                            }
                            .animation(.smooth, value: showUserId)
                           
                                
                        }
                        .textCase(.uppercase)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        
                    }
                    VStack {
                        if viewModel.conversations.isEmpty {
                            // Show a loading indicator when conversations are being fetched
                            ProgressView("..")
                                .scaleEffect(1.5, anchor: .center)
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                
                                .padding()
                                .frame(width: 50, height: 50)
                        } else {
                            // Display conversation IDs if the array is not empty
                            ScrollView {
                                ForEach(viewModel.conversations) { conversation in
                                    
                                    if let lastMessage = conversation.lastMessage {
                                        
                                        InboxRowView(isUnread: true, name: conversation.participants.filter { $0.key != viewModel.user?.userId }.values.first ?? "Unknown", text: lastMessage)
                                            .onTapGesture {
                                                goToChatView(conversation: conversation)
                                            }
                                            .padding()
                                    }
                                }
                            }
                        }}
                }
                .ignoresSafeArea(.all)
                .padding(.init(top: 10, leading: 30, bottom: 5, trailing: 30))
                .animation(.easeInOut, value: isChatViewPresented)
                .onAppear {
                    Task {
                        if viewModel.conversations.isEmpty {
                            try await viewModel.loadCurrentUser()
                            await viewModel.loadConversations()
                        }
                    }
                }
                .animation(.smooth, value: isChatViewPresented)
                .fullScreenCover(isPresented: $isNewMessageViewPresented) {
                    CreateNewMessageView()
                }
            }
        }
    }
    private func goToChatView(conversation: Conversation) {
        selectedConversationId = conversation.id
        selectedUserId = viewModel.user?.userId
        
        // Find the participant's userID that is not equal to the logged-in user's userID
        if let partnerId = conversation.participants.first(where: { $0.key != selectedUserId })?.key {
            
            
            selectedPartnerId = partnerId
            // Get the partner name from the participants dictionary using the partnerId
            selectedPartnerName = conversation.participants[partnerId]
        }
        
        withAnimation(.smooth) {
            isChatViewPresented = true
        }
    
    }
}





