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
    
    @State private var showCardSheet = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.gray.opacity(opacityBasedOnSelection()))
            
            
            .frame(width: rolodexState.selectedCard == item ? 120 : 100, height: rolodexState.selectedCard == item ? 110 : 100) // Adjust size based on selection
            .onTapGesture {
                            withAnimation {
                                
                                rolodexState.selectedCard = rolodexState.selectedCard == item ? nil : item
                                showCardSheet.toggle()
                            }
                        }
            .overlay {
                VStack {
                    Text(item.name)
                    Text(item.name2)
                    Text(item.city)
                        .foregroundColor(.white)
                }
            }
            .background(
                .ultraThinMaterial, in:
                
                    .rect(cornerRadius: 5)
                )
            .sheet(isPresented: $showCardSheet) {
                CardSheet()
                    .presentationDetents([.fraction(6.1/10), .large])
                    .presentationDragIndicator(.hidden)
            }
        
    }
    
    func opacityBasedOnSelection() -> Double {
           guard let selectedCard = rolodexState.selectedCard else {
               return 1.0 // No card is selected, normal opacity
           }
           
           return item == selectedCard ? 1.0 : 0.22 // Reduce opacity if not the selected card
       }
}


