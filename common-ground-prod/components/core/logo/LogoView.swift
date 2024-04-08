//
//  SwiftUIView.swift
//  common-ground
//
//  Created by dan crowley on 2/26/24.
//

import SwiftUI

struct LogoView: View {
    var size: CGFloat
    var namespace: Namespace.ID

    let logoColor1 = Color(UIColor(red: 66/255, green: 89/255, blue: 86/255, alpha: 0.8))
    
    var body: some View {
        
        
        LogoShape(size: size)
            .matchedGeometryEffect(id: "rectangle", in: namespace, properties: .frame, anchor: .center, isSource: true)
            .frame(width: size * 2, height: size * 2)
            .foregroundColor(logoColor1)
            .aspectRatio(1, contentMode: .fit)
            
            .rotationEffect(.degrees(-25))
            .animation(.easeInOut, value: size)
            .overlay(
                LogoShape2(size: size)
                    .matchedGeometryEffect(id: "overlay", in: namespace)
                    .foregroundColor(logoColor1)
                    .aspectRatio(1, contentMode: .fit)
                    
                    .rotationEffect(.degrees(5))
                
            
            )
            
    }
}



