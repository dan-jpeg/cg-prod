//
//  HeartView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/24/24.
//

import SwiftUI

struct HeartView: View {
    
    var hasFill: Bool = true
    
    var size: CGFloat = 10
    
    var body: some View {
        
        let offset = [-(size/5), size/4]
        let offsetOverlay = [-(size/10),0]
                        
        VStack(alignment: .center) {
            LogoViewNoNamespace(size: size, rotationEffect: 50, rotationOverlay: -38, offset: offset, offsetOverlay: offsetOverlay)
                .rotationEffect(Angle(degrees: -7))
                .padding(0)
//                    LogoViewNoNamespace(size: 40, rotationEffect: 20, rotationOverlay: 20, offset: [5 , 10])
//                       LogoViewNoNamespace(size: 40, rotationEffect: 0, rotationOverlay: 90, offset: [5 , 10])
//                        LogoViewNoNamespace(size: 40, rotationEffect: 90, rotationOverlay: 90, offset: [5 , 10])
//                        LogoViewNoNamespace(size: 40, rotationEffect: 90, rotationOverlay: 90, offset: [5 , 10])
//            Spacer()
        }
    }
}

#Preview {
    VStack {
        VStack {
            HeartView()
        }
        .frame(maxHeight: .infinity)
        VStack {
            HeartView(size: 20)
        }
        .frame(maxHeight: .infinity)
        VStack {
            HeartView(size: 30)
        }
        .frame(maxHeight: .infinity)
        
        HStack {
            
        } .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    

    
}

