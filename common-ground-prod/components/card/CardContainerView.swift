//
//  CardContainerView.swift
//  common-ground
//
//  Created by dan crowley on 2/27/24.
//

import SwiftUI

struct CardContainerView: View {
    
    var height: CGFloat
    var itemWidth: CGFloat
    
    @ObservedObject var rolodexState: RolodexViewModel
    
    @State private var items: [CardFlowItem] = [
        .init(name: "DANIEL", name2: "CROWLEY ", city: "New York"),
        .init(name: "XU ", name2: "JING YI", city: "Shanghai"),
        .init(name: "CASE RE", name2: "SOR", city: "Miami"),
        .init(name: "KANEKO", name2: "AYANO", city: "Tokyo"),
        .init(name: "GRACIE", name2: "RESOR", city: "New York")
    ]
    
    @State private var selectedCard: CardFlowItem?
    
    @State private var spacing: CGFloat = 0
    
    @State private var isSelected: Bool = false
    
    let logoColor1 = Color(UIColor(red: 194/255, green: 197/255, blue: 191/255, alpha: 0.8))
    
    
    var body: some View {
        
        VStack {
            Spacer(minLength: 0)
            CardFlowView(itemWidth: itemWidth, spacing: 30, items: items, rotation: 0) { item in
                CardView(rolodexState: rolodexState, item: item, isSelected: selectedCard == item, isAnyCardSelected: selectedCard != nil)
//                    .onTapGesture {
//                        withAnimation {
//                            if selectedCard == item {
//                                selectedCard = nil
//                            } else {
//                                selectedCard = item
//                            }
//                        }
//                    }
            }
            .frame(minHeight: height)
            
            Spacer(minLength: 0)
            
        }
        
        
    }
}


 

//#Preview {
//    CardContainerView(height: 120, itemWidth: 100, rolodexState: RolodexState())
//}
