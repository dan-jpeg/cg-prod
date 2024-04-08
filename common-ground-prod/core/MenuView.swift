//
//  MenuView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/17/24.
//

import SwiftUI

struct MenuView: View {
    
    var namespace: Namespace.ID
    @Binding var menuState: MenuState
    @Binding var selectedSlice: String
    
    var body: some View {
        VStack {
            HeaderView(namespace: namespace, squareSize: 50, menuState: $menuState)
            
            
            MultiSliceView(namespace: namespace, isSelected: $selectedSlice)
            Spacer()
            if selectedSlice != " " {
                Image(systemName: "chevron.right")
                    .asButton {
                        menuState = .mapDetail
                    }
                    .position(x: 181, y: 100)
                    .font(.system(size: 22, weight: .light))
                Spacer()
            }
        }.padding()

    }
}

//#Preview {
//    MenuView()
//}
