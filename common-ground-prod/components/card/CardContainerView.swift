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
    var connectedUsers: [ConnectedUser]
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            CardFlowView(itemWidth: itemWidth, spacing: 30, items: connectedUsers.map { CardFlowItem(name: $0.firstName ?? "", name2: $0.surname ?? "", city: $0.city ?? "") }, rotation: 0) { item in
                CardView(rolodexState: rolodexState, item: item, isSelected: rolodexState.selectedCard == item, isAnyCardSelected: rolodexState.selectedCard != nil)
            }
            .frame(minHeight: height)
            Spacer(minLength: 0)
        }
    }
}


 

//#Preview {
//    CardContainerView(height: 120, itemWidth: 100, rolodexState: RolodexState())
//}
