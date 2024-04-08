//
//  CityCardFlow.swift
//  common-ground
//
//  Created by dan crowley on 2/28/24.
//

import SwiftUI

struct CityCardFlow: View {
    
    @ObservedObject var rolodexState: RolodexViewModel
    
    
    var cityName: String
    
    var body: some View {
        VStack(alignment: .trailing){
            Text(cityName)
                .textCase(.uppercase)
                .fontWeight(.bold)
                .font(.system(size: 12))
            CardContainerView(height: 100, itemWidth: 100, rolodexState: rolodexState)
        } .frame(height: 160)
    }
}

//#Preview {
//    CityCardFlow(rolodexState: RolodexState(), cityName: "New york city")
//}
