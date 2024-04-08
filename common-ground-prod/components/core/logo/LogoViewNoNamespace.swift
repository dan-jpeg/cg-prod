//
//  LogoViewNoNamespace.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/21/24.

import SwiftUI

struct LogoViewNoNamespace: View {
    var size: CGFloat
    var rotationEffect: Double
    var rotationOverlay: Double
    var offset: [CGFloat]
    var offsetOverlay: [CGFloat]
    var color: Color

    // Define your default color value directly within the struct.
    private static let logoColor1 = Color(UIColor(red: 66/255, green: 89/255, blue: 86/255, alpha: 0.8))

    // Custom initializer.
    init(size: CGFloat, rotationEffect: Double = -25, rotationOverlay: Double = 5,
         offset: [CGFloat] = [0, 0], offsetOverlay: [CGFloat] = [0, 0],
         color: Color = LogoViewNoNamespace.logoColor1) { // Default color parameter.
        self.size = size
        self.rotationEffect = rotationEffect
        self.rotationOverlay = rotationOverlay
        self.offset = offset
        self.offsetOverlay = offsetOverlay
        self.color = color // Use the passed color or default to logoColor1.
    }

    
    var body: some View {
        
        
        
        LogoShape(size: size)
            
            .frame(width: size * 2, height: size * 2)
            .foregroundColor(color)
            .aspectRatio(1, contentMode: .fit)
            
            .rotationEffect(.degrees(rotationEffect))
            .offset(x: offset[0], y: offset[1])
            .overlay(
                LogoShape2(size: size)
                    
                    .foregroundColor(color)
                    .aspectRatio(1, contentMode: .fit)
                    
                    .rotationEffect(.degrees(rotationOverlay))
                    .offset(x: offsetOverlay[0], y: offsetOverlay[1])
                
            
            )
            .animation(.easeInOut, value: size)
    }
}



