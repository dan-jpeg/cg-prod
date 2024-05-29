//
//  SwiftUIView.swift
//  common-ground
//
//  Created by dan crowley on 3/4/24.
//

import SwiftUI


let logoColor1 = Color(UIColor(red: 75/255, green: 89/255, blue: 86/255, alpha: 0.8))
let borderColor = Color(UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 0.8))

struct CardSheet: View {
    @State private var isAnimating: Bool = false
    
    @StateObject private var viewModel = InboxViewModel()
    
    let item: CardFlowItem
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CardRow(field1: item.name, field2: item.name2, place: item.city.description)
                CardRow(field1: "MUTUAL", field2: "CONTACT", place: "CHICAGO")
                CardRow(field1: "", field2: "", place: "say hello")
                    .onTapGesture {
                        Task {
                            do {
                                let conversationId = try await  viewModel.createConversation(user2: item.userID)
                                try await viewModel.postNewMessage(conversationId: conversationId, text: "hello")
                            }
                            
                            catch {
                                
                            }
                        }
                    }
                Spacer()
            }
            .padding()
                
            
        }
    }
}
//#Preview {
//    CardSheet()
//}
// 
