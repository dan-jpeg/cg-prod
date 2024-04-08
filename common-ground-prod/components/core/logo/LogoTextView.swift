//
//  LogoTextView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/17/24.
//

import SwiftUI

struct LogoTextView: View {
    
    var namespace: Namespace.ID
    
    
    var body: some View {
        VStack {
            Text("COMMON")
            Text("GROUND")
        }
        .matchedGeometryEffect(id: "logotext", in: namespace)
        .fontWeight(.bold)
        .foregroundStyle(Color.black)
        .opacity(0.9)
        
    }
}

//#Preview {
//    LogoTextView(namespace: )
//}
