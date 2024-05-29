//
//  ChatView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/22/24.
//

import SwiftUI
import SwiftfulUI

@MainActor
final class ChatViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published private(set) var user: DBUser? = nil
    @Published var messages: [Message] = []
    @Published var chatPartner: DBUser? = nil
    @Published var isUserTyping: [String: Bool] = [:]
    
    
    
    
    func loadCurrentUser() async throws {
        
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userID: authUser.uid)
        
    }
    
    func loadChatPartner(partnerId: String) async throws {
        self.chatPartner = try await UserManager.shared.getUser(userID: partnerId)
        
    }
    
    func loadMessages(conversationId: String, userId: String) async {
        do {
            let fetchedMessages = try await ChatManager.shared.fetchMessages(conversationId: conversationId)
            self.messages = fetchedMessages
            
        } catch {
            self.errorMessage = "Failed to load messages: \(error.localizedDescription)"
        }
    }
    
    func postNewMessage(conversationId: String, recipientId: String, text: String) async throws {
        
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userID: authUser.uid)
        
        guard let user = self.user else {
            print("User is not loaded")
            return
        }
        
        let newMessage = Message(senderId: user.userId, recipientId: recipientId, // You might want to adjust this according to your design
                                 text: text, timestamp: Date(), favorite: false)
        
        print(newMessage.text)
        
        do {
            try await ChatManager.shared.postMessage(conversationId: conversationId, message: newMessage)
            // Assuming success, add the message to the local messages array to update UI
            DispatchQueue.main.async {
                self.messages.append(newMessage)
            }
        } catch {
            self.errorMessage = "Failed to post new message: \(error.localizedDescription)"
        }
    }
    
    func toggleFavorite(for messageId: String, in conversationId: String, isFavorite: Bool) async {
        do {
            try await ChatManager.shared.toggleFavorite(for: messageId, in: conversationId, isFavorite: isFavorite)
            // After toggling, you may want to reload or update the specific message in your messages array
            // to reflect the change in the UI.
            if let index = messages.firstIndex(where: { $0.id == messageId }) {
                messages[index].favorite = !isFavorite
            }
        } catch {
            self.errorMessage = "Failed to toggle favorite status: \(error.localizedDescription)"
        }
    }
    
                                                //    func updateTypingStatus(conversationId: String, userId: String, isTyping: Bool) async {
                                                //            do {
                                                //                try await ChatManager.shared.setUserTyping(conversationId: conversationId, userId: userId, isTyping: isTyping)
                                                //            } catch {
                                                //                print("Failed to update typing status: \(error)")
                                                //            }
                                                //        }
                                                //
                                                //    func startTypingListener(conversationId: String) {
                                                //        ChatManager.shared.listenForTyping(conversationId: conversationId) { [weak self] result in
                                                //            DispatchQueue.main.async {
                                                //                switch result {
                                                //                case .success(let typingStatus):
                                                //                    self?.isUserTyping = typingStatus
                                                //                case .failure(let error):
                                                //                    print("Error listening for typing updates: \(error)")
                                                //
                                                //                }
                                                //            }
                                                //        }
                                                //    }
    }



struct ChatView: View {
//    let conversation: Conversation
    let conversationId: String
    let userId: String
    let partnerId: String

    let partnerName: String
    @StateObject private var viewModel = ChatViewModel()
    
    @State private var newMessageContent = ""
    @Binding var isChatViewPresented: Bool
    @State private var isScrolling: Bool = true
    @State private var newMessageBody: String = ""
    
    @Binding var menuState: MenuState
    var namespace: Namespace.ID
    
    
    
    
//    init(isChatViewPresented: Binding<Bool>) {
//        
//        self._isChatViewPresented = isChatViewPresented
//        
//        // Generate some fake messages
//        let message1 = Message(messageId: "1", senderId: "sender1", recipientId: "recipient1", text: "Hello!", timestamp: Date(), favorite: false)
//        let message2 = Message(messageId: "2", senderId: "recipient1", recipientId: "sender1", text: "Hi there!", timestamp: Date().addingTimeInterval(60), favorite: true)
//        let message3 = Message(messageId: "3", senderId: "sender1", recipientId: "recipient1", text: "How are you?", timestamp: Date().addingTimeInterval(120), favorite: false)
//        let message4 = Message(messageId: "4", senderId: "recipient1", recipientId: "sender1", text: "U really cant wear cole haan saddle shoes in Bushwick safely 🤓 ", timestamp: Date().addingTimeInterval(180), favorite: true)
//        let message5 = Message(messageId: "5", senderId: "recipient1", recipientId: "recipient1", text: "The one on left looks pretty Jewish looking!", timestamp: Date().addingTimeInterval(240), favorite: false)
//        let message6 = Message(messageId: "6", senderId: "sender1", recipientId: "sender1", text: "he's not. P sure he's just hispanic or spanosh or smthn lol", timestamp: Date().addingTimeInterval(300), favorite: true)
//        let message7 = Message(messageId: "7", senderId: "sender1", recipientId: "sender1", text: "if the police call tell them im not home ", timestamp: Date().addingTimeInterval(1000), favorite: false)
//        let message8 = Message(messageId: "8", senderId: "sender1", recipientId: "sender1", text: " blink twice if u get this ", timestamp: Date().addingTimeInterval(1200), favorite: false)
//        
//        
//        // Create a fake conversation using the generated messages
//        let fakeConversation = Conversation(senderName: "jinni", messages: [message1, message2, message3, message4, message5, message6, message7, message8], timeAgo: "5h")
//        
//        self.conversation = fakeConversation
//        self.menuState = menuState
//        self.namespace = namespace
//    }
//    
    
        
    var body: some View {
        
        VStack {    
            ChatViewHeader(name: partnerName, menuState: $menuState, namespace: namespace, isChatViewPresented: $isChatViewPresented)
            ScrollViewWithOnScrollChanged {
                LazyVStack {
//                    if viewModel.isUserTyping.values.contains(true) {
//                        Text("Someone is typing...")
//                            .transition(.opacity)
//                            .animation(.easeInOut, value: viewModel.isUserTyping)
//                    }

                    if !viewModel.messages.isEmpty {
                        ForEach(viewModel.messages, id: \.self.id) { message in
                            MessageBubbleView(message: message.text, isScrolling: false, favorite: message.favorite, received: message.senderId != userId, onDoubleTap: {
                                 if let messageID = message.id {
                                    Task {
                                        await viewModel.toggleFavorite(for: messageID, in: conversationId, isFavorite: message.favorite)
                                    }
                                }
                            })
                                .padding(.horizontal, 16)
                        }
                    }
                }
            } onScrollChanged: { origin in
                isScrolling = false
            }
            
            ChatInputField(placeholder: "Say hi...", newMessageBody: $newMessageBody,  onEnterPressed: {
                // This closure is now correctly matching the expected type '(() -> Void)?'
                Task {
                    // This Task now correctly encapsulates the asynchronous operation.
                    
                    
                    try await viewModel.postNewMessage(conversationId: conversationId, recipientId: partnerId, text: newMessageBody)
                    
                    
                    newMessageBody = "" // Reset the text field after sending the message.
                }
                
                //            }, onTextChanged:  { newText in
                //                Task {
                //                    await viewModel.updateTypingStatus(conversationId: conversationId, userId: viewModel.user?.userId ?? "", isTyping: !newText.isEmpty)                }
                //                
                //            })
            })
            
            .padding(.bottom, 10)
          }
        .onAppear {
            Task {
               
                await viewModel.loadMessages(conversationId: conversationId, userId: userId)
             
                
            }
        
        }
        .onDisappear {
            
            viewModel.messages = []
            
        }
      }
    
        
  }
