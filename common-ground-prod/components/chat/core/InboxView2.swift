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
    @Published private(set) var user: DBUser? = nil
    @Published var conversations: [Conversation] = []
    
    
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
           } catch {
               self.errorMessage = "Failed to load conversations: \(error.localizedDescription)"
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
    
    
    @Environment(\.router) var router
    
    
    var body: some View {
        ZStack {
            if isChatViewPresented, let conversationId = selectedConversationId, let userId = selectedUserId, let partnerId = selectedPartnerId {
                            // Pass the selectedConversationId and userId to the ChatView
                ChatView(conversationId: conversationId, userId: userId, partnerId: partnerId, isChatViewPresented: $isChatViewPresented, menuState: $menuState, namespace: namespace)
                                .padding(.horizontal, 20)
                                .onDisappear {
                                    // Reset the selectedConversationId when ChatView is dismissed
                                    selectedConversationId = nil
                                    selectedUserId = nil
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
                            
                            Text("NEW MESSAGE")
                                .onTapGesture {
                                    //                                       isNewMessageViewPresented = true
                                }
                            
                            Text("\(viewModel.user!.userId)")
                        }
                        .textCase(.uppercase)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        
                    }
                    VStack {
                        if viewModel.conversations.isEmpty {
                            // Show a loading indicator when conversations are being fetched
                            ProgressView("Loading...")
                                .scaleEffect(1.5, anchor: .center)
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .padding()
                        } else {
                            // Display conversation IDs if the array is not empty
                            ScrollView {
                                ForEach(viewModel.conversations) { conversation in
                                    
                                    if let lastMessage = conversation.lastMessage {
                                        
                                        InboxRowView(isUnread: true, name: conversation.participants[1], text: lastMessage)
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
                        try await viewModel.loadCurrentUser()
                        await viewModel.loadConversations()
                        
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
        selectedPartnerId = conversation.participants.first { $0 != selectedUserId }
        withAnimation(.smooth) {
            isChatViewPresented = true
            
        }
        }
    }

//func fetchMessages(conversationId: String, userId: String) async throws -> [Message] {
//    let snapshot = try await db.collection("users").document(userId).collection("conversations").document(conversationId).collection("messages").order(by: "timestamp", descending: false).getDocuments()
//    
//}
