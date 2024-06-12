//
//  CardView.swift
//  common-ground
//
//  Created by dan crowley on 3/1/24.
//

import SwiftUI

struct CardView: View {
    
    @ObservedObject var rolodexState: RolodexViewModel
    
    
    

    
    let item: CardFlowItem 
    var isSelected: Bool
    var isAnyCardSelected: Bool
    
    @State private var flipped = false
    @State private var messageSent = false
    
    
    var body: some View {
        
        VStack {
            if !flipped {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(opacityBasedOnSelection()))
                    .frame(width: rolodexState.selectedCard == item ? 120 : 100, height: rolodexState.selectedCard == item ? 110 : 100) // Adjust size based on selection
                    .onTapGesture {
                        flipped = true
                    }
                    .overlay {
                        VStack {
                            Text(item.name)
                            Text(item.name2)
                            Text(item.city.description)
                            Text(item.hobbies.description)
                            Text(item.ageRange)
                            Text(item.industry)
                                .foregroundColor(.black)
                        }
                        .font(.caption2)
                        .textCase(.uppercase)
                        .fontWeight(.semibold  )
                    }

            } else {
                if !messageSent {
                    Text("say heyyy")
                        .onTapGesture {
                            Task {
                                do {
                                    // Try to create a conversation and get its ID.
                                    let conversationID = try await rolodexState.createConversation(user2: item.userID)                                    // Use the conversation ID to post a new message.
                                    try await rolodexState.postNewMessage(conversationId: conversationID, recipientId: item.userID, text: "heyyy")
                                    messageSent = true
                                } catch {
                                    // Handle any errors
                                    print(error)
                                }
                            }
                        }
                } else {
                    Text("msg sent!")

                }
            } 
        }
        
//            .sheet(isPresented: $showCardSheet) {
//                CardSheet(item: item)
//                    .presentationDetents([.fraction(6.1/10), .large])
//                    .presentationDragIndicator(.hidden)
//            }
//        
    }
    func opacityBasedOnSelection() -> Double {
           guard let selectedCard = rolodexState.selectedCard else {
               return 0.01 // No card is selected, normal opacity
           }
           return item == selectedCard ? 0 : 0.0 // Reduce opacity if not the selected card
       }
}


